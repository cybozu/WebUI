@testable import WebUI
import WebKit

final class EnhancedWKWebViewMock: EnhancedWKWebView {
    private(set) var loadedRequest: URLRequest?
    private(set) var loadedHTMLString: String?
    private(set) var loadedBaseURL: URL?
    private(set) var reloadCalled = false
    private(set) var goBackCalled = false
    private(set) var goForwardCalled = false
    private(set) var javaScriptString: String?

    private var _title: String?
    override var title: String? {
        get { _title }
        set { _title = newValue }
    }

    private var _url: URL?
    override var url: URL? {
        get { _url }
        set { _url = newValue }
    }

    private var _isLoading = false
    override var isLoading: Bool {
        get { _isLoading }
        set { _isLoading = newValue }
    }

    private var _estimatedProgress = Double.zero
    override var estimatedProgress: Double {
        get { _estimatedProgress }
        set { _estimatedProgress = newValue }
    }

    private var _canGoBack = false
    override var canGoBack: Bool {
        get { _canGoBack }
        set { _canGoBack = newValue }
    }

    private var _canGoForward = false
    override var canGoForward: Bool {
        get { _canGoForward }
        set { _canGoForward = newValue }
    }

    override func load(_ request: URLRequest) -> WKNavigation? {
        loadedRequest = request
        return nil
    }

    override func loadHTMLString(_ string: String, baseURL: URL?) -> WKNavigation? {
        loadedHTMLString = string
        loadedBaseURL = baseURL
        return nil
    }

    override func reload() -> WKNavigation? {
        reloadCalled = true
        return nil
    }

    override func goBack() -> WKNavigation? {
        goBackCalled = true
        return nil
    }

    override func goForward() -> WKNavigation? {
        goForwardCalled = true
        return nil
    }

    override func evaluateJavaScript(
        _ javaScriptString: String,
        completionHandler: (@MainActor (Any?, (any Error)?) -> Void)? = nil
    ) {
        self.javaScriptString = javaScriptString
        completionHandler?(true, nil)
    }
}

final class UIDelegateMock: NSObject, WKUIDelegate {}

final class NavigationDelegateMock: NSObject, WKNavigationDelegate {}

final class WebViewConfigurationMock: WKWebViewConfiguration {}
