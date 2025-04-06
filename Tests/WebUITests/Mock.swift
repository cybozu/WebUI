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

    var _title: String?
    override var title: String? { _title }

    var _url: URL?
    override var url: URL? { _url }

    var _isLoading = false
    override var isLoading: Bool { _isLoading }

    var _estimatedProgress = Double.zero
    override var estimatedProgress: Double { _estimatedProgress }

    var _canGoBack = false
    override var canGoBack: Bool { _canGoBack }

    var _canGoForward = false
    override var canGoForward: Bool { _canGoForward }

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

    #if compiler(>=6.0)
    override func evaluateJavaScript(
        _ javaScriptString: String,
        completionHandler: (@MainActor (Any?, (any Error)?) -> Void)? = nil
    ) {
        self.javaScriptString = javaScriptString
        completionHandler?(true, nil)
    }
    #else
    override func evaluateJavaScript(
        _ javaScriptString: String,
        completionHandler: ((Any?, (any Error)?) -> Void)? = nil
    ) {
        self.javaScriptString = javaScriptString
        completionHandler?(true, nil)
    }
    #endif
}

final class UIDelegateMock: NSObject, WKUIDelegate {}

final class NavigationDelegateMock: NSObject, WKNavigationDelegate {}

final class WebViewConfigurationMock: WKWebViewConfiguration {}
