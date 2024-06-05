import SwiftUI
import WebKit

struct SetUpWebViewProxyAction {
    let action: @MainActor @Sendable (WKWebView, @escaping () -> WKWebView) -> Void

    @MainActor
    func callAsFunction(_ webView: WKWebView, _ remakeHandler: @escaping () -> WKWebView) {
        action(webView, remakeHandler)
    }
}

private struct SetUpWebViewProxyActionKey: EnvironmentKey {
    static let defaultValue = SetUpWebViewProxyAction(action: { _, _ in })
}

extension EnvironmentValues {
    var setUpWebViewProxy: SetUpWebViewProxyAction {
        get { self[SetUpWebViewProxyActionKey.self] }
        set { self[SetUpWebViewProxyActionKey.self] = newValue }
    }
}
