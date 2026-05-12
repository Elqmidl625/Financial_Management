//
//  AppUITests.swift
//  Financial_ManagementUITests
//
//  Covers: UI/UX Test Case Group (basic smoke flows)
//

import XCTest

final class AppUITests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testShowsMainTabsOnLaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()
        
        XCTAssertTrue(app.buttons["Input"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Calendar"].exists)
        XCTAssertTrue(app.buttons["Report"].exists)
        XCTAssertTrue(app.buttons["More"].exists)
    }
    
    func testMoreScreenDoesNotShowAccountActions() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()
        
        app.buttons["More"].tap()
        XCTAssertTrue(app.staticTexts["Settings"].waitForExistence(timeout: 5))
        XCTAssertFalse(app.buttons["Sign Up"].exists)
        XCTAssertFalse(app.buttons["Log In"].exists)
        XCTAssertFalse(app.buttons["Sign Out"].exists)
        XCTAssertFalse(app.buttons["Delete Current Account"].exists)
    }
}

