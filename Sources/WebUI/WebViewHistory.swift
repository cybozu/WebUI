import WebKit

final class WebViewHistory: WKBackForwardList {
    private var _backList = [WKBackForwardListItem]()
    override var backList: [WKBackForwardListItem] {
        get { _backList }
        set { _backList = newValue }
    }

    private var _forwardList = [WKBackForwardListItem]()
    override var forwardList: [WKBackForwardListItem] {
        get { _forwardList }
        set { _forwardList = newValue }
    }

    func clear() {
        _backList.removeAll()
        _forwardList.removeAll()
    }
}
