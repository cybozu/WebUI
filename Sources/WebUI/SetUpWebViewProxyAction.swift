import SwiftUI
import WebKit

struct SetUpWebViewProxyAction {
    var action: @MainActor @Sendable (Remakeable<EnhancedWKWebView>) -> Void

    @MainActor
    func callAsFunction(_ webView: Remakeable<EnhancedWKWebView>) {
        action(webView)
    }
}

extension EnvironmentValues {
    @Entry var setUpWebViewProxy = SetUpWebViewProxyAction(action: { _ in })
}
