import WebKit

#if canImport(UIKit)
private typealias PlatformEnvironment = UIApplication
#elseif canImport(AppKit)
private typealias PlatformEnvironment = NSWorkspace
private extension PlatformEnvironment {
    @MainActor func open(_ url: URL) async -> Bool {
        let syncOpen: (URL) -> Bool = self.open
        return syncOpen(url)
    }
}
#endif

@MainActor
final class ContentViewState: NSObject, ObservableObject {
    enum WebDialog {
        enum Phase {
            case idle
            case presented
            case dismissing
        }

        case alert(_ message: String, _ continuation: CheckedContinuation<Void, Never>)
        case confirm(_ message: String, _ continuation: CheckedContinuation<Bool, Never>)
        case prompt(_ prompt: String, _ defaultText: String, _ continuation: CheckedContinuation<String?, Never>)

        var needsCancel: Bool {
            switch self {
            case .alert: false
            default: true
            }
        }

        var message: String {
            switch self {
            case let .alert(message, _): message
            case let .confirm(message, _): message
            case let .prompt(prompt, _, _): prompt
            }
        }
    }

    @Published var pageScaleFactor: CGFloat = 1.0
    @Published var webDialog: WebDialog?
    @Published var showDialog = false {
        didSet { updateDialogPhase(from: oldValue) }
    }
    @Published var promptInput = ""

    let configuration = WKWebViewConfiguration()
    let request = URLRequest(url: URL(string: "https://cybozu.github.io/webview-debugger")!)
    let htmlURL = Bundle.main.url(forResource: "sample", withExtension: "html")!
    let htmlString: String

    private var dialogPhase = WebDialog.Phase.idle
    // WebKit serializes JavaScript dialogs per page, so at most one request waits here.
    private var dialogDismissalWaiter: CheckedContinuation<Void, Never>?

    override init() {
        htmlString = try! String(contentsOf: htmlURL, encoding: .utf8)
        super.init()
        setCookie(name: "SampleKey", value: "SampleValue")
    }

    private func setCookie(name: String, value: String) {
        if let domain = request.url?.host(), let cookie = HTTPCookie(properties: [
            HTTPCookiePropertyKey.name: name,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/"
        ]) {
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }

    private func updateDialogPhase(from oldValue: Bool) {
        switch (oldValue, showDialog) {
        case (_, true):
            dialogPhase = .presented
        case (true, false):
            #if os(iOS)
            // SwiftUI writes `false` to `isPresented` once more after the alert has been torn down,
            // and an alert presented before that write is dropped. Keep waiting for it.
            dialogPhase = .dismissing
            #else
            // There is no second write on macOS; the binding has settled at this point.
            settleDialog()
            #endif
        case (false, false) where dialogPhase == .dismissing:
            settleDialog()
        default:
            break
        }
    }

    private func settleDialog() {
        dialogPhase = .idle
        let waiter = dialogDismissalWaiter
        dialogDismissalWaiter = nil
        waiter?.resume()
    }

    private func waitForDialogDismissal() async {
        guard dialogPhase != .idle else { return }
        await withCheckedContinuation { continuation in
            dialogDismissalWaiter = continuation
        }
    }

    private func showAlert(_ message: String) async {
        await waitForDialogDismissal()
        await withCheckedContinuation { continuation in
            webDialog = .alert(message, continuation)
            showDialog = true
        }
    }

    private func showConfirm(_ message: String) async -> Bool {
        await waitForDialogDismissal()
        return await withCheckedContinuation { continuation in
            webDialog = .confirm(message, continuation)
            showDialog = true
        }
    }

    private func showPrompt(_ prompt: String, _ defaultText: String?) async -> String? {
        await waitForDialogDismissal()
        return await withCheckedContinuation { continuation in
            webDialog = .prompt(prompt, defaultText ?? "", continuation)
            showDialog = true
        }
    }

    func zoomIn() {
        pageScaleFactor += 0.1
    }

    func zoomOut() {
        pageScaleFactor = max(pageScaleFactor - 0.1, 0.1)
    }

    func dialogOK() {
        guard let webDialog else { return }
        switch webDialog {
        case let .alert(_, continuation):
            continuation.resume()
        case let .confirm(_, continuation):
            continuation.resume(returning: true)
        case let .prompt(_, _, continuation):
            continuation.resume(returning: promptInput)
        }
    }

    func dialogCancel() {
        guard let webDialog else { return }
        switch webDialog {
        case let .alert(_, continuation):
            continuation.resume()
        case let .confirm(_, continuation):
            continuation.resume(returning: false)
        case let .prompt(_, _, continuation):
            continuation.resume(returning: nil)
        }
    }
}

extension ContentViewState: WKUIDelegate {
    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo
    ) async {
        await showAlert(message)
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo
    ) async -> Bool {
        await showConfirm(message)
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo
    ) async -> String? {
        await showPrompt(prompt, defaultText)
    }
}

extension ContentViewState: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences
    ) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
        #if canImport(UIKit)
        preferences.preferredContentMode = .mobile
        #elseif canImport(AppKit)
        preferences.preferredContentMode = .desktop
        #endif
        guard let requestedURL = navigationAction.request.url else {
            return (.cancel, preferences)
        }

        // Allow loading of schemes that should be handled inside WebView.
        guard !["http", "https", "blob", "file", "about"].contains(requestedURL.scheme) else {
            return (.allow, preferences)
        }

        // Check if the user wants to open the URL in an external app.
        let urlString = requestedURL.absoluteString
        let resultConfirm = await showConfirm("Open this link in external app?\n\(urlString)")
        guard resultConfirm else {
            return (.cancel, preferences)
        }

        // Open the URL in an external app.
        let resultOpenURL = await PlatformEnvironment.shared.open(requestedURL)
        guard !resultOpenURL else {
            return (.cancel, preferences)
        }

        // Show an alert if the external app fails to open the URL.
        await showAlert("Failed to open the link in external app.")

        return (.cancel, preferences)
    }
}
