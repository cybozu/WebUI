@testable import WebUI
import WebKit

final class WKWebViewMock: EnhancedWKWebView {
    private(set) var loadedURL: URL?
    private(set) var reloadCalled = false
    private(set) var goBackCalled = false
    private(set) var goForwardCalled = false
    private(set) var javaScriptString: String?

    override func load(_ request: URLRequest) -> WKNavigation? {
        loadedURL = request.url
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
        completionHandler: ((Any?, (any Error)?) -> Void)? = nil
    ) {
        self.javaScriptString = javaScriptString
        completionHandler?(true, nil)
    }
}

final class UIDelegateMock: NSObject, WKUIDelegate {}

final class NavigationDelegateMock: NSObject, WKNavigationDelegate {}

final class WebViewConfigurationMock: WKWebViewConfiguration {}
