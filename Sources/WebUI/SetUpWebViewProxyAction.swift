import SwiftUI

struct SetUpWebViewProxyAction {
    let action: (EnhancedWKWebView) -> Void

    func callAsFunction(_ webView: EnhancedWKWebView) {
        action(webView)
    }
}

private struct SetUpWebViewProxyActionKey: EnvironmentKey {
    static var defaultValue = SetUpWebViewProxyAction(action: { _ in })
}

extension EnvironmentValues {
    var setUpWebViewProxy: SetUpWebViewProxyAction {
        get { self[SetUpWebViewProxyActionKey.self] }
        set { self[SetUpWebViewProxyActionKey.self] = newValue }
    }
}

