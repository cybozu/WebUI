import SwiftUI
import WebKit

#if os(iOS)
typealias OSView = UIView
#elseif os(macOS)
typealias OSView = NSView
#endif

final class EnhancedWKWebViewWrapper: OSView {
    var webView: EnhancedWKWebView

    init(configuration: WKWebViewConfiguration) {
        webView = EnhancedWKWebView(frame: .zero, configuration: configuration)
        super.init(frame: .zero)
        addSubview(webView)
        setConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func remakeWebView(configuration: WKWebViewConfiguration) {
        webView.removeFromSuperview()
        webView = EnhancedWKWebView(frame: .zero, configuration: configuration)
        addSubview(webView)
        setConstraints()
    }

    private func setConstraints() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        webView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
