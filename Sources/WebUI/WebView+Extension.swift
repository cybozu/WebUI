import SwiftUI
import WebKit

#if os(iOS)
private typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
private typealias ViewRepresentable = NSViewRepresentable
#endif

extension WebView: View {
    /// The content and behavior of the web view.
    public var body: some View {
        _WebView(parent: self) {
            proxy.setUp($0)
        }
    }

    struct _WebView: ViewRepresentable {
        let parent: WebView
        let setUpWebViewHandler: (WKWebView) -> Void

        @MainActor
        private func makeEnhancedWKWebView() -> EnhancedWKWebView {
            let webView = EnhancedWKWebView(frame: .zero, configuration: parent.configuration)
            parent.applyModifiers(to: webView)
            setUpWebViewHandler(webView)
            return webView
        }

        @MainActor
        private func updateEnhancedWKWebView(_ webView: EnhancedWKWebView) {
            parent.applyModifiers(to: webView)
        }

        #if os(iOS)
        func makeUIView(context: Context) -> EnhancedWKWebView {
            makeEnhancedWKWebView()
        }

        func updateUIView(_ webView: EnhancedWKWebView, context: Context) {
            updateEnhancedWKWebView(webView)
        }
        #elseif os(macOS)
        func makeNSView(context: Context) -> EnhancedWKWebView {
            makeEnhancedWKWebView()
        }

        func updateNSView(_ webView: EnhancedWKWebView, context: Context) {
            updateEnhancedWKWebView(webView)
        }
        #endif
    }
}
