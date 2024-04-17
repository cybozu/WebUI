@testable import WebUI
import XCTest

final class WebViewProxyTests: XCTestCase {
    @MainActor
    func test_load_the_specified_URL() {
        let sut = WebViewProxy()
        let webViewMock = WKWebViewMock()
        sut.setUp(webViewMock)
        let url = URL(string: "https://www.example.com")!
        sut.load(url: url)
        XCTAssertEqual(webViewMock.loadedURL, url)
    }

    @MainActor
    func test_reload() {
        let sut = WebViewProxy()
        let webViewMock = WKWebViewMock()
        sut.setUp(webViewMock)
        sut.reload()
        XCTAssertTrue(webViewMock.reloadCalled)
    }

    @MainActor
    func test_go_back() {
        let sut = WebViewProxy()
        let webViewMock = WKWebViewMock()
        sut.setUp(webViewMock)
        sut.goBack()
        XCTAssertTrue(webViewMock.goBackCalled)
    }

    @MainActor
    func test_go_forward() {
        let sut = WebViewProxy()
        let webViewMock = WKWebViewMock()
        sut.setUp(webViewMock)
        sut.goForward()
        XCTAssertTrue(webViewMock.goForwardCalled)
    }

    @MainActor
    func test_evaluate_JavaScript() async throws {
        let sut = WebViewProxy()
        let webViewMock = WKWebViewMock()
        sut.setUp(webViewMock)
        let actual = try await sut.evaluateJavaScript("test")
        XCTAssertEqual(webViewMock.javaScriptString, "test")
        let result = try XCTUnwrap(actual as? Bool)
        XCTAssertTrue(result)
    }
}
