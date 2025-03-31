import WebKit

/// This is a workaround for the absence of refresh control in macOS.
#if canImport(UIKit)
typealias RefreshControl = UIRefreshControl
#else
struct RefreshControl {
    enum ControlEvent {
        case valueChanged
    }

    func addTarget(_ target: Any?, action: Selector, for controlEvents: ControlEvent) {}
    func endRefreshing() {}
}

extension WKWebView {
    struct ScrollView {
        var bounces = false
        var refreshControl: RefreshControl? = .init()
    }

    var scrollView: ScrollView {
        get { .init() }
        set {}
    }
}
#endif
