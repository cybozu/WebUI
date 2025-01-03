@testable import WebUI
import os
import SwiftUI
import XCTest

final class WebViewReaderTests: XCTestCase {
    @MainActor
    func test_WebViewProxy_will_also_be_destroyed_if_WebViewReader_is_destroyed() {
        let proxyClient = OSAllocatedUnfairLock<WebViewProxy?>(initialState: nil)
        let sut = WebViewReader { proxy in
            WebView()
                .onAppear {
                    proxyClient.withLock { $0 = proxy }
                }
        }
        UIHostingController(rootView: sut)._render(seconds: 0)
        let actual = proxyClient.withLock(\.self)
        addTeardownBlock { [weak actual] in
            XCTAssertNil(actual)
        }
    }
}
