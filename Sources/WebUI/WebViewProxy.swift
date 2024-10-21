import SwiftUI
import WebKit

/// A proxy value that supports programmatic control of the web view within a view hierarchy.
///
/// You don't create instances of `WebViewProxy` directly. Instead, your
/// ``WebViewReader`` receives an instance of `WebViewProxy` in its
/// `content` view builder.
@available(iOS 16.4, macOS 13.3, *)
@MainActor
public final class WebViewProxy: ObservableObject {
    private(set) weak var webView: Remakeable<EnhancedWKWebView>?

    /// The page title.
    @Published public private(set) var title: String?

    /// The active URL.
    @Published public private(set) var url: URL?

    /// A Boolean value indicating whether the view is currently loading content.
    @Published public private(set) var isLoading = false

    /// An estimate of what fraction of the current navigation has been completed.
    @Published public private(set) var estimatedProgress: Double = .zero

    /// A Boolean value indicating whether there is a back item in the back-forward list that can be navigated to.
    @Published public private(set) var canGoBack = false

    /// A Boolean value indicating whether there is a forward item in the back-forward list that can be navigated to.
    @Published public private(set) var canGoForward = false
    
    @Published public private(set) var customUserAgent: String?
    
    private var tasks: [Task<Void, Never>] = []

    nonisolated init() {}

    deinit {
        tasks.forEach { $0.cancel() }
    }

    func setUp(_ webView: Remakeable<EnhancedWKWebView>) {
        self.webView = webView
        observe(webView.wrappedValue)

        webView.onRemake { [weak self] in
            guard let self else { return }
            observe($0)
        }
    }

    private func observe(_ webView: WKWebView) {
        tasks.forEach { $0.cancel() }
        tasks.removeAll()

        tasks = [
            Task { @MainActor in
                for await value in webView.publisher(for: \.title).bufferedValues() {
                    self.title = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.url).bufferedValues() {
                    self.url = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.isLoading).bufferedValues() {
                    self.isLoading = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.estimatedProgress).bufferedValues() {
                    self.estimatedProgress = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.canGoBack).bufferedValues() {
                    self.canGoBack = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.canGoForward).bufferedValues() {
                    self.canGoForward = value
                }
            },
            Task { @MainActor in
                for await value in webView.publisher(for: \.customUserAgent).bufferedValues() {
                    self.customUserAgent = value
                }
            },
        ]
    }

    /// Navigates to a requested URL.
    /// - Parameters:
    ///   - request: The request specifying the URL to which to navigate.
    public func load(request: URLRequest) {
        webView?.wrappedValue.load(request)
    }

    /// Loads the contents of the specified HTML string and navigates to it.
    /// - Parameters:
    ///   - string: The string to use as the contents of the webpage.
    ///   - baseURL: The base URL to use when the system resolves relative URLs within the HTML string.
    public func loadHTMLString(_ string: String, baseURL: URL?) {
        webView?.wrappedValue.loadHTMLString(string, baseURL: baseURL)
    }

    /// Reloads the current webpage.
    public func reload() {
        webView?.wrappedValue.reload()
    }

    /// Navigates to the back item in the back-forward list.
    public func goBack() {
        webView?.wrappedValue.goBack()
    }

    /// Navigates to the forward item in the back-forward list.
    public func goForward() {
        webView?.wrappedValue.goForward()
    }
    
    public func setAgent(_ customUserAgent: String) {
        webView?.wrappedValue.customUserAgent = customUserAgent
    }
    
    /// Evaluates the specified JavaScript string.
    /// - Parameters:
    ///   - javaScriptString: The JavaScript string to evaluate.
    /// - Returns: The result of the script evaluation, or nil if WebViewProxy loses its reference to the ``WebView``.
    /// - Throws: `WebKit.WKError`
    ///
    /// The following example evaluates JavaScript and displaying "Hello World" when the ``WebView`` appears.
    ///
    /// ```swift
    /// var body: some View {
    ///     WebViewReader { proxy in
    ///         WebView()
    ///             .task {
    ///                 do {
    ///                     let script = #"window.alert("Hello World");"#
    ///                     try await proxy.evaluateJavaScript(script)
    ///                 } catch {
    ///                     print(error.localizedDescription)
    ///                 }
    ///             }
    ///     }
    /// }
    /// ```
    @discardableResult
    public func evaluateJavaScript(_ javaScriptString: String) async throws -> Any? {
        guard let webView else { return nil }
        return try await withCheckedThrowingContinuation { continuation in
            webView.wrappedValue.evaluateJavaScript(javaScriptString) { result, error in
                Task { @MainActor in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: result)
                    }
                }
            }
        }
    }

    /// Clears all properties managed by `WKWebView`.
    ///
    /// As a side effect, the WKWebView instance will be remade.
    public func clearAll() {
        webView?.remake()
    }
}
