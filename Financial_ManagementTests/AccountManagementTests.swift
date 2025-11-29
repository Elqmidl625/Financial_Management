//
//  AccountManagementTests.swift
//  Financial_ManagementTests
//
//  Covers: Account / Wallet Management Group (Accounts / Wallets)
//

import XCTest
@testable import Financial_Management

final class AccountManagementTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
    }
    
    func testSaveAccountIsNormalizedAndUnique() {
        UserSession.shared.saveAccount(email: " Alice@Example.com ")
        UserSession.shared.saveAccount(email: "alice@example.com")
        XCTAssertEqual(UserSession.shared.savedAccounts.count, 1)
        XCTAssertEqual(UserSession.shared.savedAccounts.first, "alice@example.com")
    }
    
    func testRemoveSavedAccount() {
        UserSession.shared.savedAccounts = []
        UserSession.shared.saveAccount(email: "bob@example.com")
        XCTAssertEqual(UserSession.shared.savedAccounts.count, 1)
        UserSession.shared.removeSavedAccount(email: " Bob@Example.com ")
        XCTAssertTrue(UserSession.shared.savedAccounts.isEmpty)
    }
    
    func testSetCurrentUserPersistsToDefaults() {
        UserSession.shared.setCurrentUser(email: "charlie@example.com")
        XCTAssertEqual(UserSession.shared.currentUserId, "charlie@example.com")
        let stored = UserDefaults.standard.string(forKey: "currentUserId")
        XCTAssertEqual(stored, "charlie@example.com")
    }
}


