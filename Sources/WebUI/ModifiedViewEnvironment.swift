import SwiftUI
import WebKit

/// A value with a view environment applied to it.
public struct ModifiedViewEnvironment<Content, Value> {
    var content: Content
    var keyPath: ReferenceWritableKeyPath<WKWebView, Value>
    var value: Value
}

extension View {
    /// Sets a custom value for a `WKWebView` property.
    ///
    /// This modifier allows you to customize specific properties of the underlying `WKWebView`
    /// that are not directly exposed through the standard ``WebView`` modifiers.
    ///
    /// - Parameters:
    ///   - keyPath: A key path that indicates property of `WKWebView` to set.
    ///   - value: The new value to set for the item specified by keyPath.
    ///
    /// - Returns: A view that has the given value set in its property.
    @available(*, deprecated, message: "This ViewModifier has no guarantee of functionality in any version. For reliable property settings, please use the existing ViewModifiers in WebView or start a discussion by opening an Issue/Pull Request in the cybozu/WebUI GitHub repository.")
    public func viewEnvironment<Value>(
        _ keyPath: ReferenceWritableKeyPath<WKWebView, Value>,
        _ value: Value
    ) -> ModifiedViewEnvironment<Self, Value> {
        .init(content: self, keyPath: keyPath, value: value)
    }
}

extension ModifiedViewEnvironment: WebViewRepresentable, View where Content: WebViewRepresentable {
    var configuration: WKWebViewConfiguration {
        content.configuration
    }

    func applyModifiers(to webView: EnhancedWKWebView) {
        content.applyModifiers(to: webView)
        webView[keyPath: keyPath] = value
    }

    func loadInitialRequest(in webView: EnhancedWKWebView) {
        content.loadInitialRequest(in: webView)
    }
}
