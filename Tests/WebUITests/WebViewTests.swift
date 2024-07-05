@testable import WebUI
import XCTest

final class WebViewTests: XCTestCase {
    @MainActor
    func test_applyModifiers_uiDelegate() {
        let uiDelegateMock = UIDelegateMock()
        let sut = WebView().uiDelegate(uiDelegateMock)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(uiDelegateMock === webViewMock.uiDelegate)
    }

    @MainActor
    func test_applyModifiers_navigationDelegate() {
        let navigationDelegateMock = NavigationDelegateMock()
        let sut = WebView().navigationDelegate(navigationDelegateMock)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(navigationDelegateMock === webViewMock.navigationDelegateProxy.delegate)
    }

    @MainActor
    func test_applyModifiers_isInspectable() {
        let sut = WebView().allowsInspectable(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.isInspectable)
    }

    @MainActor
    func test_applyModifiers_allowsBackForwardNavigationGestures() {
        let sut = WebView().allowsBackForwardNavigationGestures(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.allowsBackForwardNavigationGestures)
    }

    @MainActor
    func test_applyModifiers_allowsLinkPreview() {
        let sut = WebView().allowsLinkPreview(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.allowsLinkPreview)
    }

    @MainActor
    func test_applyModifiers_isRefreshable() {
        let sut = WebView().refreshable()
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        XCTAssertTrue(webViewMock.isRefreshable)
    }

    @MainActor
    func test_loadInitialRequest_do_not_load_URL_request_if_request_is_not_specified_in_init() {
        let sut = WebView()
        let webViewMock = EnhancedWKWebViewMock()
        sut.loadInitialRequest(in: webViewMock)
        XCTAssertNil(webViewMock.loadedRequest)
    }

    @MainActor
    func test_loadInitialRequest_load_URL_request_if_request_is_specified_in_init() {
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        let sut = WebView(request: request)
        let webViewMock = EnhancedWKWebViewMock()
        sut.loadInitialRequest(in: webViewMock)
        XCTAssertEqual(webViewMock.loadedRequest, request)
    }
}
