import SwiftUI

#if os(iOS)
private typealias ViewRepresentable = UIViewRepresentable
#elseif os(macOS)
private typealias ViewRepresentable = NSViewRepresentable
#endif

extension WebView: View {
    /// The content and behavior of the web view.
    public var body: some View {
        _WebView(parent: self)
    }

    struct _WebView: ViewRepresentable {
        @Environment(\.setUpWebView) private var setUpWebView
        @Environment(\.setUpRemakeHandler) private var setUpRemakeHandler

        let parent: WebView

        @MainActor
        private func makeView() -> EnhancedWKWebViewWrapper {
            let view = EnhancedWKWebViewWrapper(configuration: parent.configuration)
            setUpWebView(view.webView)
            setUpRemakeHandler {
                view.remakeWebView(configuration: parent.configuration)
            }
            parent.applyModifiers(to: view.webView)
            parent.loadInitialRequest(in: view.webView)
            return view
        }

        @MainActor
        private func updateView(_ view: EnhancedWKWebViewWrapper) {
            parent.applyModifiers(to: view.webView)
        }

        #if os(iOS)
        func makeUIView(context: Context) -> EnhancedWKWebViewWrapper {
            makeView()
        }

        func updateUIView(_ view: EnhancedWKWebViewWrapper, context: Context) {
            updateView(view)
        }
        #elseif os(macOS)
        func makeNSView(context: Context) -> EnhancedWKWebViewWrapper {
            makeView()
        }

        func updateNSView(_ view: EnhancedWKWebViewWrapper, context: Context) {
            updateView(view)
        }
        #endif
    }
}
