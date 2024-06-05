import SwiftUI
import WebKit

struct SetUpWebViewProxyAction {
    let action: @MainActor @Sendable (WKWebView) -> Void

    @MainActor
    func callAsFunction(_ webView: WKWebView) {
        action(webView)
    }
}

private struct SetUpWebViewProxyActionKey: EnvironmentKey {
    static let defaultValue = SetUpWebViewProxyAction(action: { _ in })
}

extension EnvironmentValues {
    var setUpWebViewProxy: SetUpWebViewProxyAction {
        get { self[SetUpWebViewProxyActionKey.self] }
        set { self[SetUpWebViewProxyActionKey.self] = newValue }
    }
}

