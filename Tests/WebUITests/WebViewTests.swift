import Foundation
import Testing

@testable import WebUI

struct WebViewTests {
    @MainActor @Test
    func test_applyModifiers_uiDelegate() {
        let uiDelegateMock = UIDelegateMock()
        let sut = WebView().uiDelegate(uiDelegateMock)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(uiDelegateMock === webViewMock.uiDelegate)
    }

    @MainActor @Test
    func test_applyModifiers_navigationDelegate() {
        let navigationDelegateMock = NavigationDelegateMock()
        let sut = WebView().navigationDelegate(navigationDelegateMock)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(navigationDelegateMock === webViewMock.navigationDelegateProxy.delegate)
    }

    @MainActor @Test
    func test_applyModifiers_isInspectable() {
        let sut = WebView().allowsInspectable(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(webViewMock.isInspectable)
    }

    @MainActor @Test
    func test_applyModifiers_allowsBackForwardNavigationGestures() {
        let sut = WebView().allowsBackForwardNavigationGestures(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(webViewMock.allowsBackForwardNavigationGestures)
    }

    @MainActor @Test
    func test_applyModifiers_allowsLinkPreview() {
        let sut = WebView().allowsLinkPreview(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(webViewMock.allowsLinkPreview)
    }

    @MainActor @Test
    func test_applyModifiers_allowsScrollViewBounces() {
        let sut = WebView().allowsScrollViewBounces(true)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(webViewMock.allowsScrollViewBounces)
    }

    @MainActor @Test
    func test_applyModifiers_isRefreshable() {
        let sut = WebView().refreshable()
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(webViewMock.isRefreshable)
    }

    @MainActor @Test
    func test_applyModifiers_isOpeque() {
        let sut = WebView().isOpaque(false)
        let webViewMock = EnhancedWKWebViewMock()
        sut.applyModifiers(to: webViewMock)
        #expect(!webViewMock.isOpaque)
    }

    @MainActor @Test
    func test_loadInitialRequest_do_not_load_URL_request_if_request_is_not_specified_in_init() {
        let sut = WebView()
        let webViewMock = EnhancedWKWebViewMock()
        sut.loadInitialRequest(in: webViewMock)
        #expect(webViewMock.loadedRequest == nil)
    }

    @MainActor @Test
    func test_loadInitialRequest_load_URL_request_if_request_is_specified_in_init() {
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        let sut = WebView(request: request)
        let webViewMock = EnhancedWKWebViewMock()
        sut.loadInitialRequest(in: webViewMock)
        #expect(webViewMock.loadedRequest == request)
    }
}
