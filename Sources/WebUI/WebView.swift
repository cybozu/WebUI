import SwiftUI
import WebKit

/// A view that displays interactive web content.
///
/// This is a wrapper around WKWebView aimed at simplifying web view implementation in SwiftUI.
/// The following example creates a WebView that initially loads [example.com](https://www.example.com).
///
/// ```swift
/// var body: some View {
///     WebView(url: URL(string: "https://www.example.com")!)
/// }
/// ```
@available(iOS 16.4, macOS 13.3, *)
public struct WebView {
    let configuration: WKWebViewConfiguration

    private let url: URL?

    private var uiDelegate: (any WKUIDelegate)?
    private var navigationDelegate: (any WKNavigationDelegate)?
    private var isInspectable = false
    private var allowsBackForwardNavigationGestures = false
    private var allowsLinkPreview = true
    private var isRefreshable = false

    /// Creates new WebView.
    /// - Parameters:
    ///   - url: The initial URL to load.
    ///   - configuration: The configuration for the new web view.
    public init(url: URL? = nil, configuration: WKWebViewConfiguration = .init()) {
        self.url = url
        self.configuration = configuration
    }

    /// Sets WKUIDelegate to WebView.
    /// - Parameters:
    ///   - uiDelegate: A type that conforms to the `WKUIDelegate` protocol.
    ///     You have control over web view behavior when you use a delegate.
    /// - Returns: WebView that applies the received delegate.
    public func uiDelegate(_ uiDelegate: any WKUIDelegate) -> Self {
        var modified = self
        modified.uiDelegate = uiDelegate
        return modified
    }

    /// Sets WKNavigationDelegate to WebView.
    /// - Parameters:
    ///   - navigationDelegate: A type that conforms to the `WKNavigationDelegate` protocol.
    ///     You have control over web view behavior when you use a delegate.
    /// - Returns: WebView that applies the received delegate.
    public func navigationDelegate(_ navigationDelegate: any WKNavigationDelegate) -> Self {
        var modified = self
        modified.navigationDelegate = navigationDelegate
        return modified
    }

    /// Sets value for isInspectable to WebView.
    /// - Parameters:
    ///   - enabled: A Boolean value that indicates whether you can inspect the view with Safari Web Inspector.
    /// - Returns: WebView that controls whether you can inspect this view with Safari Web Inspector.
    public func allowsInspectable(_ enabled: Bool) -> Self {
        var modified = self
        modified.isInspectable = enabled
        return modified
    }

    /// Sets value for allowsBackForwardNavigationGestures to WebView.
    /// - Parameters:
    ///   - enabled: A Boolean value that determines whether users are allowed to navigate by horizontal swipe gestures in this WebView.
    /// - Returns: WebView that controls whether users are allowed to navigate by horizontal swipe gestures.
    public func allowsBackForwardNavigationGestures(_ enabled: Bool) -> Self {
        var modified = self
        modified.allowsBackForwardNavigationGestures = enabled
        return modified
    }

    /// Sets value for allowsLinkPreview to WebView.
    /// - Parameters:
    ///   - enabled: A Boolean value that determines whether users can preview link destinations
    ///     and detected data such as addresses and phone numbers in this WebView.
    /// - Returns: WebView that controls whether users can preview link destinations and detected data.
    public func allowsLinkPreview(_ enabled: Bool) -> Self {
        var modified = self
        modified.allowsLinkPreview = enabled
        return modified
    }

    /// Marks this view as refreshable.
    ///
    /// Applying this modifier to a WebView reloads page contents when users perform an action to refresh.
    ///
    /// For example, when you apply this modifier on iOS and iPadOS,
    /// the WebView enables a pull-to-refresh gesture that reloads the page contents.
    public func refreshable() -> Self {
        var modified = self
        modified.isRefreshable = true
        return modified
    }

    @MainActor
    func applyModifiers(to webView: EnhancedWKWebView) {
        webView.uiDelegate = uiDelegate
        webView.navigationDelegate = navigationDelegate
        webView.isInspectable = isInspectable
        webView.allowsBackForwardNavigationGestures = allowsBackForwardNavigationGestures
        webView.allowsLinkPreview = allowsLinkPreview
        webView.isRefreshable = isRefreshable
    }

    @MainActor
    func loadsURLAtFirst(to webView: EnhancedWKWebView) {
        if let url {
            webView.load(URLRequest(url: url))
        }
    }
}
