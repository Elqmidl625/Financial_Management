//
//  FilteringTests.swift
//  Financial_ManagementTests
//
//  Covers: Transaction Filtering Group
//

import XCTest
import CoreData
@testable import Financial_Management

final class FilteringTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
        
        // Seed two users
        try UserSession.shared.ensureUser(email: "u1@example.com", userName: "U1", password: "p")
        try UserSession.shared.ensureUser(email: "u2@example.com", userName: "U2", password: "p")
        
        // Current is u2 by ensureUser, switch back to u1
        UserSession.shared.setCurrentUser(email: "u1@example.com")
    }
    
    func testFetchAllForUserReturnsOnlyTheirRows() throws {
        let ctx = InformationProvider.shared.viewContext
        
        // Create 2 rows for u1
        try makeInformation(userEmail: "u1@example.com", name: "Food", money: "10", spent: true, date: .now)
        try makeInformation(userEmail: "u1@example.com", name: "Coffee", money: "5", spent: true, date: .now)
        
        // Create 1 row for u2
        try makeInformation(userEmail: "u2@example.com", name: "Sallary", money: "100", spent: false, date: .now)
        
        waitForCoreDataPropagation()
        
        let u1Id = UserSession.userId(from: "u1@example.com")
        let u2Id = UserSession.userId(from: "u2@example.com")
        
        var fetch = Information.allForUser(userId: u1Id)
        var results = try ctx.fetch(fetch)
        XCTAssertEqual(results.count, 2)
        
        fetch = Information.allForUser(userId: u2Id)
        results = try ctx.fetch(fetch)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Sallary")
    }
    
    func testFetchAllForCurrentUserIncludesNilAndEmptyForDefault() throws {
        // Current user default
        UserSession.shared.currentUserId = "default"
        
        let ctx = InformationProvider.shared.viewContext
        
        // Insert three rows: nil userId, empty userId, and "default"
        let info1 = Information(context: ctx)
        info1.name = "Legacy1"
        info1.money = "1"
        info1.spentOrGained = true
        info1.userId = nil
        
        let info2 = Information(context: ctx)
        info2.name = "Legacy2"
        info2.money = "2"
        info2.spentOrGained = false
        info2.userId = ""
        
        let info3 = Information(context: ctx)
        info3.name = "DefaultUser"
        info3.money = "3"
        info3.spentOrGained = true
        info3.userId = "default"
        
        try ctx.save()
        
        let fetch = Information.allForCurrentUser()
        let results = try ctx.fetch(fetch)
        // Should include all 3
        XCTAssertEqual(results.filter { $0.name.hasPrefix("Legacy") || $0.name == "DefaultUser" }.count, 3)
    }
    
    // MARK: - Helpers
    private func makeInformation(userEmail: String,
                                 name: String,
                                 money: String,
                                 spent: Bool,
                                 date: Date) throws {
        let ctx = InformationProvider.shared.viewContext
        let info = Information(context: ctx)
        info.name = name
        info.money = money
        info.spentOrGained = spent
        info.dateOfInfor = date
        info.userId = UserSession.userId(from: userEmail)
        try ctx.save()
    }
}


