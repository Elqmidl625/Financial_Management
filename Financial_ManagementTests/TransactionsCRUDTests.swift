//
//  TransactionsCRUDTests.swift
//  Financial_ManagementTests
//
//  Covers: Income/Expense Transaction Group (Transactions CRUD)
//

import XCTest
import CoreData
@testable import Financial_Management

final class TransactionsCRUDTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
        // Ensure we operate under a non-default user
        try UserSession.shared.ensureUser(email: "crud@example.com", userName: "CRUD", password: "p")
    }
    
    func testCreateReadUpdateDeleteTransaction() throws {
        let session = UserSession.shared
        let userId = session.currentUserId
        
        // Create
        let vm = EditInputViewModel(provider: .shared)
        vm.information.name = "Food"
        vm.information.imageName = "food"
        vm.information.spentOrGained = true
        vm.information.money = "250"
        vm.information.note = "Lunch"
        try vm.save()
        
        waitForCoreDataPropagation()
        
        // Read
        let ctx = InformationProvider.shared.viewContext
        var fetch = Information.allForUser(userId: userId)
        var results = try ctx.fetch(fetch)
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "Food")
        XCTAssertEqual(results.first?.money, "250")
        
        // Update
        if let info = results.first {
            info.money = "300"
            info.note = "Lunch updated"
            try ctx.save()
        }
        results = try ctx.fetch(fetch)
        XCTAssertEqual(results.first?.money, "300")
        XCTAssertEqual(results.first?.note, "Lunch updated")
        
        // Delete
        if let info = results.first {
            ctx.delete(info)
            try ctx.save()
        }
        results = try ctx.fetch(fetch)
        XCTAssertEqual(results.count, 0)
    }
}


