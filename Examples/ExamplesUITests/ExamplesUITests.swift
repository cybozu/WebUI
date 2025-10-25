import XCTest

final class ExamplesUITests: XCTestCase {
    @MainActor
    func testHappyPath() {
        let app = XCUIApplication()
        app.launch()

        // MARK: WebViewProxy
        XCTContext.runActivity(named: "WebViewProxy.load(request:)") { _ in
            XCTAssertTrue(app.webViews.staticTexts["History"].waitForExistence(timeout: 15))
        }

        XCTContext.runActivity(named: "WebViewProxy.reload()") { _ in
            app.webViews.buttons["Add"].tap()
            XCTAssertTrue(app.webViews.staticTexts["1"].waitForExistence(timeout: 3))
            app.buttons["Reload"].tap()
            XCTAssertTrue(app.webViews.staticTexts["0"].waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "WebViewProxy.goBack()") { _ in
            app.webViews.buttons["Add"].tap()
            XCTAssertTrue(app.webViews.staticTexts["1"].waitForExistence(timeout: 3))
            app.buttons["Go Back"].tap()
            XCTAssertTrue(app.webViews.staticTexts["0"].waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "WebViewProxy.goForward()") { _ in
            app.buttons["Go Forward"].tap()
            XCTAssertTrue(app.webViews.staticTexts["1"].waitForExistence(timeout: 3))
        }

        // WebViewProxy.evaluateJavaScript(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        // MARK: WebView
        // WebView.allowsInspectable(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        // WebView.allowsBackForwardNavigationGestures(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        // WebView.allowsLinkPreview(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        // WebView.allowsScrollViewBounces(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        // WebView.allowsOpaqueDrawing(_:)
        // Skip this test case as it is not possible to reproduce the operation.

        XCTContext.runActivity(named: "WebView.refreshable()") { _ in
            let historyLabel = app.webViews.staticTexts["History"]
            XCTAssertTrue(historyLabel.waitForExistence(timeout: 3))
            let start = historyLabel.coordinate(withNormalizedOffset: .zero)
            let end = start.withOffset(CGVector(dx: 0, dy: 300))
            start.press(forDuration: 0, thenDragTo: end)
            XCTAssertTrue(app.webViews.staticTexts["0"].waitForExistence(timeout: 3))
        }

        XCTContext.runActivity(named: "WebViewProxy.loadHTMLString()") { _ in
            app.buttons["More"].tap()
            app.buttons["Load HTML String"].tap()
            XCTAssertTrue(app.webViews.staticTexts["Sample"].waitForExistence(timeout: 15))
        }

        XCTContext.runActivity(named: "WebViewProxy.clearAll()") { _ in
            app.buttons["More"].tap()
            app.buttons["Clear"].tap()
            XCTAssertFalse(app.buttons["Go Back"].isEnabled)
            XCTAssertFalse(app.buttons["Go Forward"].isEnabled)
        }

        XCTContext.runActivity(named: "WebView.uiDelegate(_:)") { _ in
            let confirmButton = app.webViews.buttons["Confirm"]
            XCTAssertTrue(confirmButton.waitForExistence(timeout: 15))
            confirmButton.tap()
            XCTAssertTrue(app.alerts.staticTexts["Confirm Test"].waitForExistence(timeout: 3))
            app.alerts.buttons["OK"].tap()
            XCTAssertTrue(app.alerts.staticTexts["Result: OK"].waitForExistence(timeout: 3))
            app.alerts.buttons["OK"].tap()
        }

        XCTContext.runActivity(named: "WebView.init(configuration:)") { _ in
            app.webViews.buttons["Cookies"].tap()
            XCTAssertTrue(app.alerts.staticTexts["SampleKey = SampleValue"].waitForExistence(timeout: 3))
            app.alerts.buttons["OK"].tap()
        }

        XCTContext.runActivity(named: "WebView.navigationDelegate(_:)") { _ in
            app.webViews.buttons["sms://"].tap()
            let expectMessage = "Open this link in external app? sms://"
            XCTAssertTrue(app.alerts.staticTexts[expectMessage].waitForExistence(timeout: 3))
            app.alerts.buttons["OK"].tap()
            let smsApp = XCUIApplication(bundleIdentifier: "com.apple.MobileSMS")
            XCTAssertTrue(smsApp.wait(for: .runningForeground, timeout: 3))
        }
    }
}
