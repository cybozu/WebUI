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
    weak var webView: EnhancedWKWebView?

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

    private var task: Task<Void, Never>?

    nonisolated init() {}

    deinit {
        task?.cancel()
    }

    func setUp(_ webView: EnhancedWKWebView) {
        self.webView = webView

        task = Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.title).bufferedValues() {
                        self.title = value
                    }
                }

                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.url).bufferedValues() {
                        self.url = value
                    }
                }

                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.isLoading).bufferedValues() {
                        self.isLoading = value
                    }
                }

                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.estimatedProgress).bufferedValues() {
                        self.estimatedProgress = value
                    }
                }

                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.canGoBack).bufferedValues() {
                        self.canGoBack = value
                    }
                }

                group.addTask { @MainActor in
                    for await value in webView.publisher(for: \.canGoForward).bufferedValues() {
                        self.canGoForward = value
                    }
                }
            }
        }
    }

    /// Navigates to a requested URL.
    /// - Parameters:
    ///   - request: The request specifying the URL to which to navigate.
    public func load(request: URLRequest) {
        webView?.load(request)
    }

    /// Reloads the current webpage.
    public func reload() {
        webView?.reload()
    }

    /// Navigates to the back item in the back-forward list.
    public func goBack() {
        webView?.goBack()
    }

    /// Navigates to the forward item in the back-forward list.
    public func goForward() {
        webView?.goForward()
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
            webView.evaluateJavaScript(javaScriptString) { result, error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: result)
                }
            }
        }
    }

    public func clean() {
        webView?.clearHistory()
    }
}
