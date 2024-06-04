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
        @Environment(\.setUpWebViewProxy) private var setUpWebViewProxy

        let parent: WebView

        @MainActor
        private func makeView() -> EnhancedWKWebViewWrapper {
            let view = EnhancedWKWebViewWrapper(configuration: parent.configuration)
            setUpWebViewProxy(view.webView)
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
