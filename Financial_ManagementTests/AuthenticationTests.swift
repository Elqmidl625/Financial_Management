//
//  AuthenticationTests.swift
//  Financial_ManagementTests
//
//  Covers: User Registration / Login Group (Authentication)
//

import XCTest
import CoreData
@testable import Financial_Management

final class AuthenticationTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
    }
    
    func testUserIdNormalization() {
        let raw = "  Alice@Example.com "
        let id = UserSession.userId(from: raw)
        XCTAssertEqual(id, "alice@example.com")
    }
    
    func testCreateUserAndLoginSuccess() throws {
        let email = "user@test.com"
        let pass = "secret"
        
        XCTAssertFalse(try UserSession.shared.userExists(email: email))
        _ = try UserSession.shared.createUser(email: email, userName: "User", password: pass)
        XCTAssertTrue(try UserSession.shared.userExists(email: email))
        
        let ok = try UserSession.shared.login(email: email, password: pass)
        XCTAssertTrue(ok)
        XCTAssertEqual(UserSession.shared.currentUserId, UserSession.userId(from: email))
    }
    
    func testLoginFailsWithWrongPassword() throws {
        let email = "user2@test.com"
        _ = try UserSession.shared.createUser(email: email, userName: "User2", password: "correct")
        
        let ok = try UserSession.shared.login(email: email, password: "wrong")
        XCTAssertFalse(ok)
        // current user should still be default because login failed
        XCTAssertEqual(UserSession.shared.currentUserId, "default")
    }
    
    func testEnsureUserCreatesAndFetches() throws {
        let email = "ensured@example.com"
        let created = try UserSession.shared.ensureUser(email: email, userName: "Ensured", password: "p")
        XCTAssertEqual(created.email, email)
        // subsequent ensure should fetch the same user (no duplicate)
        let fetched = try UserSession.shared.ensureUser(email: email)
        XCTAssertEqual(created.objectID, fetched.objectID)
    }
    
    func testDeleteAccountRemovesUserAndTransactionsAndResetsSession() throws {
        let email = "del@example.com"
        let pass = "123"
        let user = try UserSession.shared.createUser(email: email, userName: "Del", password: pass)
        UserSession.shared.setCurrentUser(email: email)
        UserSession.shared.saveAccount(email: email)
        
        // Create a couple of transactions for this user
        let vm = EditInputViewModel(provider: .shared)
        vm.information.name = "Food"
        vm.information.imageName = "food"
        vm.information.spentOrGained = true
        vm.information.money = "100"
        try vm.save()
        
        vm.startNewInformation(spentOrGained: false)
        vm.information.name = "Salary"
        vm.information.imageName = "salary"
        vm.information.money = "500"
        try vm.save()
        
        waitForCoreDataPropagation()
        
        // Verify data present
        let ctx = InformationProvider.shared.viewContext
        let infoReq: NSFetchRequest<Information> = Information.allForUser(userId: user.userId)
        let beforeInfos = try ctx.fetch(infoReq)
        XCTAssertGreaterThanOrEqual(beforeInfos.count, 2)
        XCTAssertTrue(UserSession.shared.savedAccounts.contains(email))
        XCTAssertEqual(UserSession.shared.currentUserId, user.userId)
        
        // Delete account
        try UserSession.shared.deleteAccount(email: email, password: pass)
        
        // Verify removed
        let afterInfos = try ctx.fetch(infoReq)
        XCTAssertEqual(afterInfos.count, 0)
        XCTAssertFalse(try UserSession.shared.userExists(email: email))
        XCTAssertFalse(UserSession.shared.savedAccounts.contains(email))
        XCTAssertEqual(UserSession.shared.currentUserId, "default")
    }
}


