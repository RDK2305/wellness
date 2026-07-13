//
//  WellnessCompanionUITests.swift
//  WellnessCompanion Watch AppUITests
//
//  Launches the app twice to capture Dashboard -> Insights and, fresh,
//  Dashboard -> About Health Data, attaching a real screenshot at each
//  stop. Relaunching between screens sidesteps watchOS's fiddly
//  back-swipe gesture timing rather than relying on it. Used by CI
//  (.github/workflows/watchos-build-and-screenshot.yml) to produce
//  genuine watchOS Simulator captures of all three required screens.
//  Author: Raman Kumari
//

import XCTest

final class WellnessCompanionUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testDashboardAndInsights() throws {
        let app = XCUIApplication()
        app.launch()

        // HealthKit authorization has no entitlement in CI, so the app
        // settles into its denied-state UI quickly; the nav links below
        // are shown regardless of authorization state.
        sleep(3)
        attachScreenshot(named: "01-Dashboard", of: app)

        let insightsLink = app.buttons["Insights"]
        XCTAssertTrue(insightsLink.waitForExistence(timeout: 5), "Insights nav link not found on Dashboard")
        insightsLink.tap()
        sleep(1)
        attachScreenshot(named: "02-Insights", of: app)
    }

    func testAboutHealthData() throws {
        let app = XCUIApplication()
        app.launch()
        sleep(3)

        let healthLink = app.buttons["Health Data Info"]
        XCTAssertTrue(healthLink.waitForExistence(timeout: 5), "Health Data Info nav link not found on Dashboard")
        healthLink.tap()
        sleep(1)
        attachScreenshot(named: "03-AboutHealthData", of: app)
    }

    private func attachScreenshot(named name: String, of app: XCUIApplication) {
        let screenshot = app.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
