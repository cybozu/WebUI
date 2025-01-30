import os
import SwiftUI
import Testing

@testable import WebUI

struct WebViewReaderTests {
    @MainActor @Test
    func WebViewProxy_will_also_be_destroyed_if_WebViewReader_is_destroyed() async {
        weak var actual = await withCheckedContinuation { continuation in
            let sut = WebViewReader { proxy in
                WebView()
                    .onAppear {
                        continuation.resume(returning: proxy)
                    }
            }
            UIHostingController(rootView: sut)._render(seconds: 0)
        }
        #expect(actual == nil)
    }
}
