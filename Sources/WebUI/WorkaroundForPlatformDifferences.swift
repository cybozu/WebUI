import WebKit

/// This is a workaround for APIs that are available in UIKit but not in macOS.
#if canImport(UIKit)
public typealias ContentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior
typealias RefreshControl = UIRefreshControl
#else
public enum ContentInsetAdjustmentBehavior {
    case automatic
    case scrollableAxes
    case never
    case always
}

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
        var contentInsetAdjustmentBehavior = ContentInsetAdjustmentBehavior.automatic
        var refreshControl: RefreshControl? = .init()
    }

    var scrollView: ScrollView {
        get { .init() }
        set {}
    }
}
#endif
