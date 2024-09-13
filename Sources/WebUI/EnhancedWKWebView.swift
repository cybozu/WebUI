import WebKit

/// This is a workaround for the absence of refresh control in macOS.
#if os(iOS)
typealias RefreshControl = UIRefreshControl
#elseif os(macOS)
struct RefreshControl {
    enum ControlEvent {
        case valueChanged
    }
    func addTarget(_ target: Any?, action: Selector, for controlEvents: ControlEvent) {}
    func endRefreshing() {}
}
#endif

class EnhancedWKWebView: WKWebView {
    override var navigationDelegate: (any WKNavigationDelegate)? {
        get {
            navigationDelegateProxy
        }
        set {
            navigationDelegateProxy.delegate = newValue
            super.navigationDelegate = navigationDelegateProxy
        }
    }

    var isRefreshable = false {
        willSet {
            #if os(iOS)
            if newValue {
                self.scrollView.refreshControl = refreshControl
            } else {
                self.scrollView.refreshControl = nil
            }
            #endif
        }
    }

    private(set) var navigationDelegateProxy: NavigationDelegateProxy!

    private lazy var refreshControl = {
        let _refreshControl = RefreshControl()
        _refreshControl.addTarget(self, action: #selector(reload as () -> WKNavigation?), for: .valueChanged)
        return _refreshControl
    }()

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        navigationDelegateProxy = NavigationDelegateProxy(refreshControl: refreshControl)
        super.navigationDelegate = navigationDelegateProxy
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final class NavigationDelegateProxy: NSObject {
        weak var delegate: (any WKNavigationDelegate)?

        let refreshControl: RefreshControl

        init(refreshControl: RefreshControl) {
            self.refreshControl = refreshControl
        }

        override func responds(to aSelector: Selector!) -> Bool {
            super.responds(to: aSelector) || delegate?.responds(to: aSelector) == true
        }

        override func forwardingTarget(for aSelector: Selector!) -> Any? {
            guard let delegate, delegate.responds(to: aSelector) else {
                return super.forwardingTarget(for: aSelector)
            }

            return delegate
        }
    }
}

extension EnhancedWKWebView.NavigationDelegateProxy: WKNavigationDelegate {
    private func endRefreshing() {
        Task { @MainActor [refreshControl] in
            refreshControl.endRefreshing()
        }
    }

    func webView(
        _ webView: WKWebView,
        didFail navigation: WKNavigation!,
        withError error: any Error
    ) {
        endRefreshing()
        delegate?.webView?(webView, didFail: navigation, withError: error)
    }

    func webView(
        _ webView: WKWebView,
        didFailProvisionalNavigation navigation: WKNavigation!,
        withError error: any Error
    ) {
        endRefreshing()
        delegate?.webView?(webView, didFailProvisionalNavigation: navigation, withError: error)
    }

    func webView(
        _ webView: WKWebView,
        didFinish navigation: WKNavigation!
    ) {
        endRefreshing()
        delegate?.webView?(webView, didFinish: navigation)
    }
}
