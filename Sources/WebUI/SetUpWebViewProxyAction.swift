import SwiftUI
import WebKit

struct SetUpWebViewProxyAction {
    var action: @MainActor @Sendable (Remakeable<EnhancedWKWebView>) -> Void

    @MainActor
    func callAsFunction(_ webView: Remakeable<EnhancedWKWebView>) {
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
