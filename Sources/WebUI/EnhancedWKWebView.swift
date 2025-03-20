import WebKit

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

    #if canImport(UIKit)
    var allowsScrollViewBounces = true {
        willSet {
            self.scrollView.bounces = newValue
        }
    }
    #endif

    var allowsOpaqueDrawing = true {
        willSet {
            #if canImport(UIKit)
            isOpaque = newValue
            #endif
        }
    }

    #if canImport(UIKit)
    var isRefreshable = false {
        willSet {
            if newValue {
                self.scrollView.refreshControl = refreshControl
            } else {
                self.scrollView.refreshControl = nil
            }
        }
    }
    #endif

    private(set) var navigationDelegateProxy: NavigationDelegateProxy!

    #if canImport(UIKit)
    private lazy var refreshControl = {
        let _refreshControl = UIRefreshControl()
        _refreshControl.addTarget(self, action: #selector(reload as () -> WKNavigation?), for: .valueChanged)
        return _refreshControl
    }()
    #endif

    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        #if canImport(UIKit)
        navigationDelegateProxy = NavigationDelegateProxy(refreshControl: refreshControl)
        #else
        navigationDelegateProxy = NavigationDelegateProxy()
        #endif
        super.navigationDelegate = navigationDelegateProxy
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    final class NavigationDelegateProxy: NSObject {
        weak var delegate: (any WKNavigationDelegate)?

        #if canImport(UIKit)
        let refreshControl: UIRefreshControl

        init(refreshControl: UIRefreshControl) {
            self.refreshControl = refreshControl
        }
        #endif

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
        #if canImport(UIKit)
        Task { @MainActor [refreshControl] in
            refreshControl.endRefreshing()
        }
        #endif
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
