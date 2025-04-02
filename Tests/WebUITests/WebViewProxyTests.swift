import Foundation
import Testing

@testable import WebUI

struct WebViewProxyTests {
    @MainActor @Test
    func property_binding_title() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(title: "dummy") as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.title == "dummy")
    }

    @MainActor @Test
    func property_binding_url() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(url: URL(string: "https://www.example.com")!) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.url == URL(string: "https://www.example.com")!)
    }

    @MainActor @Test
    func property_binding_isLoading() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(isLoading: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.isLoading)
    }

    @MainActor @Test
    func property_binding_estimatedProgress() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(estimatedProgress: 0.5) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.estimatedProgress == 0.5)
    }

    @MainActor @Test
    func property_binding_canGoBack() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(canGoBack: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.canGoBack)
    }

    @MainActor @Test
    func property_binding_canGoForward() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(canGoForward: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.canGoForward)
    }

    #if canImport(UIKit)
    @MainActor @Test
    func property_binding_contentSize() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(contentSize: .init(width: 50, height: 50)) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.contentSize.equalTo(.init(width: 50, height: 50)))
    }

    @MainActor @Test
    func property_binding_contentOffset() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(contentOffset: .init(x: 50, y: 50)) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        try await Task.sleep(for: .seconds(0.1))
        #expect(sut.contentOffset.equalTo(.init(x: 50, y: 50)))
    }
    #endif

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
