import SwiftUI
import WebKit

@MainActor
protocol WebViewRepresentable: View {
    var configuration: WKWebViewConfiguration { get }

    func applyModifiers(to webView: EnhancedWKWebView)
    func loadInitialRequest(in webView: EnhancedWKWebView)
}

extension WebViewRepresentable {
    /// The content and behavior of the web view.
    public var body: some View {
        _WebView(parent: self)
    }
}

#if canImport(UIKit)
private typealias ViewRepresentable = UIViewRepresentable
#elseif canImport(AppKit)
private typealias ViewRepresentable = NSViewRepresentable
#endif

private struct _WebView: ViewRepresentable {
    @Environment(\.setUpWebViewProxy) private var setUpWebViewProxy

    var parent: any WebViewRepresentable

    @MainActor
    private func makeView() -> Remakeable<EnhancedWKWebView> {
        let webView = Remakeable<EnhancedWKWebView> {
            let wrappedView = EnhancedWKWebView(frame: .zero, configuration: parent.configuration)
            parent.applyModifiers(to: wrappedView)
            return wrappedView
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

    #if canImport(UIKit)
    func makeUIView(context: Context) -> Remakeable<EnhancedWKWebView> {
        makeView()
    }

    func updateUIView(_ view: Remakeable<EnhancedWKWebView>, context: Context) {
        updateView(view)
    }
    #elseif canImport(AppKit)
    func makeNSView(context: Context) -> Remakeable<EnhancedWKWebView> {
        makeView()
    }

    func updateNSView(_ view: Remakeable<EnhancedWKWebView>, context: Context) {
        updateView(view)
    }
    #endif
}
