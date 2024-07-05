@testable import WebUI
import XCTest

final class WebViewProxyTests: XCTestCase {
    @MainActor
    func test_load_the_specified_URLRequest() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        sut.load(request: request)
        XCTAssertEqual((webViewMock.wrappedValue as! EnhancedWKWebViewMock).loadedRequest, request)
    }

    @MainActor
    func test_reload() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.reload()
        XCTAssertTrue((webViewMock.wrappedValue as! EnhancedWKWebViewMock).reloadCalled)
    }

    @MainActor
    func test_go_back() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.goBack()
        XCTAssertTrue((webViewMock.wrappedValue as! EnhancedWKWebViewMock).goBackCalled)
    }

    @MainActor
    func test_go_forward() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.goForward()
        XCTAssertTrue((webViewMock.wrappedValue as! EnhancedWKWebViewMock).goForwardCalled)
    }

    @MainActor
    func test_evaluate_JavaScript() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await sut.evaluateJavaScript("test")
        XCTAssertEqual((webViewMock.wrappedValue as! EnhancedWKWebViewMock).javaScriptString, "test")
        let result = try XCTUnwrap(actual as? Bool)
        XCTAssertTrue(result)
    }

    @MainActor
    func test_clear_all() async {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let oldInstance = sut.webView?.wrappedValue

        sut.clearAll()

        let newInstance = sut.webView?.wrappedValue

        XCTAssertNotEqual(oldInstance, newInstance)
    }
}
