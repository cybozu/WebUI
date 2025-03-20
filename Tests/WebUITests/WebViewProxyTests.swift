import Foundation
import Testing

@testable import WebUI

struct WebViewProxyTests {
    @MainActor @Test
    func load_the_specified_URLRequest() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let request = URLRequest(url: URL(string: "https://www.example.com")!)
        sut.load(request: request)
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).loadedRequest == request)
    }

    @MainActor @Test
    func load_html_string() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.loadHTMLString("<dummy/>", baseURL: URL(string: "/dummy")!)
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).loadedHTMLString == "<dummy/>")
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).loadedBaseURL == URL(string: "/dummy")!)
    }

    @MainActor @Test
    func reload() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.reload()
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).reloadCalled)
    }

    @MainActor @Test
    func go_back() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.goBack()
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).goBackCalled)
    }

    @MainActor @Test
    func go_forward() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.goForward()
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).goForwardCalled)
    }
    
    @MainActor @Test
    func stop_loadnig() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        sut.stopLoading()
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).stopLoadingCalled)
    }

    @MainActor @Test
    func evaluate_JavaScript() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await sut.evaluateJavaScript("test")
        #expect((webViewMock.wrappedValue as! EnhancedWKWebViewMock).javaScriptString == "test")
        let result = try #require(actual as? Bool)
        #expect(result)
    }

    @MainActor @Test
    func clear_all() {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock() as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let oldInstance = sut.webView?.wrappedValue
        sut.clearAll()
        let newInstance = sut.webView?.wrappedValue
        #expect(oldInstance != newInstance)
    }
}
