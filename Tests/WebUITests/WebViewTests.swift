@testable import WebUI
import XCTest

final class WebViewTests: XCTestCase {
    @MainActor
    func test_applyModifiers_uiDelegate() {
        let uiDelegateMock = UIDelegateMock()
        let sut = WebView().uiDelegate(uiDelegateMock)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(uiDelegateMock === webViewMock.uiDelegate)
    }

    @MainActor
    func test_applyModifiers_navigationDelegate() {
        let navigationDelegateMock = NavigationDelegateMock()
        let sut = WebView().navigationDelegate(navigationDelegateMock)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(navigationDelegateMock === webViewMock.navigationDelegateProxy.delegate)
    }

    @MainActor
    func test_applyModifiers_isInspectable() {
        let sut = WebView().allowsInspectable(true)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.isInspectable)
    }

    @MainActor
    func test_applyModifiers_allowsBackForwardNavigationGestures() {
        let sut = WebView().allowsBackForwardNavigationGestures(true)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.allowsBackForwardNavigationGestures)
    }

    @MainActor
    func test_applyModifiers_allowsLinkPreview() {
        let sut = WebView().allowsLinkPreview(true)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.allowsLinkPreview)
    }

    @MainActor
    func test_applyModifiers_isRefreshable() {
        let sut = WebView().refreshable()
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.isRefreshable)
    }

    @MainActor
    func test_applyModifiers_init_with_specified_URL() {
        let url = URL(string: "https://www.example.com")!
        let sut = WebView(url: url)
        let webViewMock = WKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertEqual(webViewMock.loadedURL, url)
    }
}
