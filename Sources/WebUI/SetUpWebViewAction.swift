import SwiftUI
import WebKit

struct SetUpWebViewAction {
    let action: @MainActor @Sendable (WKWebView) -> Void

    @MainActor
    func callAsFunction(_ webView: WKWebView) {
        action(webView)
    }
}

private struct SetUpWebViewActionKey: EnvironmentKey {
    static let defaultValue = SetUpWebViewAction(action: { _ in })
}

extension EnvironmentValues {
    var setUpWebView: SetUpWebViewAction {
        get { self[SetUpWebViewActionKey.self] }
        set { self[SetUpWebViewActionKey.self] = newValue }
    }
}
