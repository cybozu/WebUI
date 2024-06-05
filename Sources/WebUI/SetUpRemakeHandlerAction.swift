import SwiftUI
import WebKit

struct SetUpRemakeHandlerAction {
    let action: @MainActor @Sendable (@escaping () -> WKWebView) -> Void

    @MainActor
    func callAsFunction(_ remakeHandler: @escaping () -> WKWebView) {
        action(remakeHandler)
    }
}

private struct SetUpRemakeHandlerActionKey: EnvironmentKey {
    static let defaultValue = SetUpRemakeHandlerAction(action: { _ in })
}

extension EnvironmentValues {
    var setUpRemakeHandler: SetUpRemakeHandlerAction {
        get { self[SetUpRemakeHandlerActionKey.self] }
        set { self[SetUpRemakeHandlerActionKey.self] = newValue }
    }
}
