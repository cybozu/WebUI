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
        private func makeView() -> Remakeable<EnhancedWKWebView> {
            let webView = Remakeable {
                EnhancedWKWebView(frame: .zero, configuration: parent.configuration)
            }
            setUpWebViewProxy(webView)
            parent.applyModifiers(to: webView.wrappedValue)
            parent.loadInitialRequest(in: webView.wrappedValue)
            return webView
        }

        @MainActor
        private func updateView(_ view: Remakeable<EnhancedWKWebView>) {
            parent.applyModifiers(to: view.wrappedValue)
        }

        #if os(iOS)
        func makeUIView(context: Context) -> Remakeable<EnhancedWKWebView> {
            makeView()
        }

        func updateUIView(_ view: Remakeable<EnhancedWKWebView>, context: Context) {
            updateView(view)
        }
        #elseif os(macOS)
        func makeNSView(context: Context) -> Remakeable<EnhancedWKWebView> {
            makeView()
        }

        func updateNSView(_ view: Remakeable<EnhancedWKWebView>, context: Context) {
            updateView(view)
        }
        #endif
    }
}
