@preconcurrency import Combine
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
        let actual = try await waitForValue(
            in: sut.$title.values,
            equalsTo: "dummy",
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_url() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(url: URL(string: "https://www.example.com")!) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$url.values,
            equalsTo: URL(string: "https://www.example.com")!,
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_isLoading() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(isLoading: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$isLoading.values,
            equalsTo: true,
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_estimatedProgress() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(estimatedProgress: 0.5) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$estimatedProgress.values,
            equalsTo: 0.5,
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_canGoBack() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(canGoBack: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$canGoBack.values,
            equalsTo: true,
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_canGoForward() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(canGoForward: true) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$canGoForward.values,
            equalsTo: true,
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    #if canImport(UIKit)
    @MainActor @Test
    func property_binding_contentSize() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(contentSize: .init(width: 50, height: 50)) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$_contentSize.values,
            equalsTo: CGSize(width: 50, height: 50),
            timeout: .seconds(0.1)
        )
        #expect(actual)
    }

    @MainActor @Test
    func property_binding_contentOffset() async throws {
        let sut = WebViewProxy()
        let webViewMock = Remakeable {
            EnhancedWKWebViewMock(contentOffset: .init(x: 50, y: 50)) as EnhancedWKWebView
        }
        sut.setUp(webViewMock)
        let actual = try await waitForValue(
            in: sut.$_contentOffset.values,
            equalsTo: CGPoint(x: 50, y: 50),
            timeout: .seconds(0.1)
        )
        #expect(actual)
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

private func waitForValue<V: Equatable & Sendable>(
    in sequence: AsyncPublisher<Published<V>.Publisher>,
    equalsTo expectedValue: V,
    timeout: Duration
) async throws -> Bool {
    try await withThrowingTaskGroup(of: Bool.self) { group in
        defer { group.cancelAll() }

        group.addTask {
            await sequence.first { $0 == expectedValue } != nil
        }

        group.addTask {
            try await Task.sleep(for: timeout)
            return false
        }

        guard let result = try await group.next() else {
            return false
        }
        return result
    }
}
