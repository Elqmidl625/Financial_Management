//
//  SecuritySessionTests.swift
//  Financial_ManagementTests
//
//  Covers: Validation & Security Group (Security / Session Management)
//

import XCTest
import CoreData
@testable import Financial_Management

final class SecuritySessionTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
    }
    
    func testDeleteAccountRequiresCorrectPassword() throws {
        let email = "secure@example.com"
        _ = try UserSession.shared.createUser(email: email, userName: "Secure", password: "pwd")
        XCTAssertThrowsError(try UserSession.shared.deleteAccount(email: email, password: "wrong")) { error in
            guard case UserSession.AccountError.invalidPassword = error else {
                XCTFail("Expected invalidPassword")
                return
            }
        }
        // User still exists
        XCTAssertTrue(try UserSession.shared.userExists(email: email))
    }
    
    func testCurrentUserIdPersistsToUserDefaults() {
        UserSession.shared.currentUserId = "abc"
        XCTAssertEqual(UserDefaults.standard.string(forKey: "currentUserId"), "abc")
    }
    
    func testSavedAccountsPersistToUserDefaults() {
        UserSession.shared.savedAccounts = []
        UserSession.shared.saveAccount(email: "persist@example.com")
        let stored = UserDefaults.standard.array(forKey: "savedAccounts") as? [String]
        XCTAssertEqual(stored, ["persist@example.com"])
    }
    
    func testInformationDefaultsToCurrentUserOnInsert() {
        UserSession.shared.currentUserId = "u-test"
        let ctx = InformationProvider.shared.viewContext
        let info = Information(context: ctx)
        XCTAssertEqual(info.userId, "u-test")
    }
}


