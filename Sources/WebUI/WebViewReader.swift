import SwiftUI

/// A view that provides programmatic control by working with a proxy to access a known web view within a view hierarchy.
///
/// The web view reader's content view builder receives a ``WebViewProxy`` instance;
/// you use the proxy's ``WebViewProxy/load(request:)`` to perform loading the URL.
///
/// The following example creates a ``WebView`` that loads [example.com](https://www.example.com) when it appears.
///
/// ```swift
/// var body: some View {
///     WebViewReader { proxy in
///         WebView()
///             .onAppear {
///                 proxy.load(request: URLRequest(url: URL(string: "https://www.example.com")!))
///             }
///     }
/// }
/// ```
@available(iOS 16.4, macOS 13.3, *)
public struct WebViewReader<Content: View>: View {
    @StateObject private var proxy = WebViewProxy()

    private let content: (WebViewProxy) -> Content

    /// Creates an instance that can perform programmatic control of its child web view.
    /// - Parameters:
    ///   - content: The reader's content, containing one web view.
    ///     This view builder receives a ``WebViewProxy`` instance that you use to perform control.
    public init(@ViewBuilder content: @escaping (WebViewProxy) -> Content) {
        self.content = content
    }

    /// The content and behavior of the view.
    public var body: some View {
        content(proxy)
            .environment(\.setUpWebViewProxy, SetUpWebViewProxyAction(action: {
                proxy.setUp($0)
            }))
    }
}
