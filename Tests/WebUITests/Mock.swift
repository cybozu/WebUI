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
    override var title: String? { _title }

    private var _url: URL?
    override var url: URL? { _url }

    private var _isLoading: Bool = false
    override var isLoading: Bool { _isLoading }

    private var _estimatedProgress: Double = .zero
    override var estimatedProgress: Double { _estimatedProgress }

    private var _canGoBack: Bool = false
    override var canGoBack: Bool { _canGoBack }

    private var _canGoForward: Bool = false
    override var canGoForward: Bool { _canGoForward }

    #if canImport(UIKit)
    private var _contentSize: CGSize = .zero
    private var _contentOffset: CGPoint = .zero
    #endif

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

extension EnhancedWKWebViewMock {
    convenience init(title: String) {
        self.init()
        _title = title
    }

    convenience init(url: URL) {
        self.init()
        _url = url
    }

    convenience init(isLoading: Bool) {
        self.init()
        _isLoading = isLoading
    }

    convenience init(estimatedProgress: Double) {
        self.init()
        _estimatedProgress = estimatedProgress
    }

    convenience init(canGoBack: Bool) {
        self.init()
        _canGoBack = canGoBack
    }

    convenience init(canGoForward: Bool) {
        self.init()
        _canGoForward = canGoForward
    }

    #if canImport(UIKit)
    convenience init(contentSize: CGSize) {
        self.init()
        scrollView.contentSize = contentSize
    }

    convenience init(contentOffset: CGPoint) {
        self.init()
        scrollView.contentOffset = contentOffset
    }
    #endif
}
