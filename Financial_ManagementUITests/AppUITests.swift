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
    
    func testShowsAuthOnLaunchWhenLoggedOut() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()
        
        // Expect the Auth screen
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 5))
        // Check segmented control options are present
        XCTAssertTrue(app.segmentedControls.buttons["Sign Up"].exists)
        XCTAssertTrue(app.segmentedControls.buttons["Log In"].exists)
    }
    
    func testSignUpFlowDismissesToMainTabs() {
        let app = XCUIApplication()
        app.launchArguments = ["-uiTestReset"]
        app.launch()
        
        // Fill sign up form
        let emailField = app.textFields["Email"]
        XCTAssertTrue(emailField.waitForExistence(timeout: 5))
        emailField.tap()
        emailField.typeText("ui_test@example.com")
        
        let userNameField = app.textFields["User name"]
        userNameField.tap()
        userNameField.typeText("UITest")
        
        let passwordField = app.secureTextFields["Password"]
        passwordField.tap()
        passwordField.typeText("123456")
        
        let confirmField = app.secureTextFields["Confirm password"]
        confirmField.tap()
        confirmField.typeText("123456")
        
        app.buttons["SignUpSubmit"].tap()
        
        // Confirmation dialog appears - choose Not now
        let notNow = app.buttons["Not now"]
        XCTAssertTrue(notNow.waitForExistence(timeout: 5))
        notNow.tap()
        
        // Verify main tabs visible
        XCTAssertTrue(app.buttons["Input"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.buttons["Calendar"].exists)
        XCTAssertTrue(app.buttons["Report"].exists)
        XCTAssertTrue(app.buttons["More"].exists)
    }
}


