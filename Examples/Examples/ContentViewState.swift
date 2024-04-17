//
//  ContentViewState.swift
//  Examples
//
//  Created by ky0me22 on 2024/02/01.
//

import Foundation
import WebKit

@MainActor
final class ContentViewState: NSObject, ObservableObject {
    enum WebDialog {
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

    @Published var webDialog: WebDialog?
    @Published var showDialog = false
    @Published var promptInput = ""

    let configuration = WKWebViewConfiguration()
    let requestURL = URL(string: "https://cybozu.github.io/webview-debugger")!

    override init() {
        super.init()
        setCookie(name: "SampleKey", value: "SampleValue")
    }

    private func setCookie(name: String, value: String) {
        if let domain = requestURL.host(), let cookie = HTTPCookie(properties: [
            HTTPCookiePropertyKey.name: name,
            HTTPCookiePropertyKey.value: value,
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/"
        ]) {
            configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
    }

    private func showAlert(_ message: String, _ continuation: CheckedContinuation<Void, Never>) {
        webDialog = .alert(message, continuation)
        showDialog = true
    }

    private func showConfirm(_ message: String, _ continuation: CheckedContinuation<Bool, Never>) {
        webDialog = .confirm(message, continuation)
        showDialog = true
    }

    private func showPrompt(_ prompt: String, _ defaultText: String?, _ continuation: CheckedContinuation<String?, Never>) {
        webDialog = .prompt(prompt, defaultText ?? "", continuation)
        showDialog = true
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
        await withCheckedContinuation { continuation in
            showAlert(message, continuation)
        }
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo
    ) async -> Bool {
        await withCheckedContinuation { continuation in
            showConfirm(message, continuation)
        }
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo
    ) async -> String? {
        await withCheckedContinuation { continuation in
            showPrompt(prompt, defaultText, continuation)
        }
    }
}

extension ContentViewState: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        preferences: WKWebpagePreferences
    ) async -> (WKNavigationActionPolicy, WKWebpagePreferences) {
        guard let requestedURL = navigationAction.request.url else {
            return (.cancel, preferences)
        }

        // Allow loading of schemes that should be handled inside WebView.
        guard !["http", "https", "blob", "file", "about"].contains(requestedURL.scheme) else {
            return (.allow, preferences)
        }

        // Check if the user wants to open the URL in an external app.
        let resultConfirm = await withCheckedContinuation { continuation in
            let urlString = requestedURL.absoluteString
            showConfirm("Open this link in external app?\n\(urlString)", continuation)
        }
        guard resultConfirm else {
            return (.cancel, preferences)
        }

        // Open the URL in an external app.
        #if os(iOS)
        let resultOpenURL = await UIApplication.shared.open(requestedURL)
        #elseif os(macOS)
        let resultOpenURL = NSWorkspace.shared.open(requestedURL)
        #endif
        guard !resultOpenURL else {
            return (.cancel, preferences)
        }

        // Show an alert if the external app fails to open the URL.
        await withCheckedContinuation { continuation in
            showAlert("Failed to open the link in external app.", continuation)
        }

        return (.cancel, preferences)
    }
}
