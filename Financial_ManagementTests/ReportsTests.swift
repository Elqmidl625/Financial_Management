//
//  ReportsTests.swift
//  Financial_ManagementTests
//
//  Covers: Reports / Analytics Group (Reports)
//

import XCTest
import CoreData
@testable import Financial_Management

final class ReportsTests: XCTestCase {
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        TestHelper.resetUserDefaults()
        TestHelper.deleteAllEntities()
        try UserSession.shared.ensureUser(email: "report@example.com", userName: "Report", password: "p")
    }
    
    func testMonthlyTotalsCalculation() throws {
        let ctx = InformationProvider.shared.viewContext
        let cal = Calendar.current
        let now = Date()
        let thisMonth = now
        let lastMonth = cal.date(byAdding: .month, value: -1, to: now)!
        
        // Seed this month: spent 30 (10 + 20), gained 100
        try makeInfo(name: "Food", money: "10", spent: true, date: thisMonth)
        try makeInfo(name: "Coffee", money: "20", spent: true, date: thisMonth)
        try makeInfo(name: "Sallary", money: "100", spent: false, date: thisMonth)
        
        // Seed last month: spent 5, gained 7 (should be ignored)
        try makeInfo(name: "Food", money: "5", spent: true, date: lastMonth)
        try makeInfo(name: "Allowance", money: "7", spent: false, date: lastMonth)
        
        try ctx.save()
        
        // Fetch current user's info
        let fetch = Information.allForUser(userId: UserSession.shared.currentUserId)
        let infos = try ctx.fetch(fetch)
        
        let month = cal.component(.month, from: thisMonth)
        let year = cal.component(.year, from: thisMonth)
        
        var spent = 0
        var gained = 0
        for info in infos {
            let m = cal.component(.month, from: info.dateOfInfor)
            let y = cal.component(.year, from: info.dateOfInfor)
            if m == month && y == year {
                if info.spentOrGained {
                    spent += (Int(info.money) ?? 0)
                } else {
                    gained += (Int(info.money) ?? 0)
                }
            }
        }
        XCTAssertEqual(spent, 30)
        XCTAssertEqual(gained, 100)
        
        // Category aggregation (spent only)
        let totalFood = infos.filter {
            cal.component(.month, from: $0.dateOfInfor) == month &&
            cal.component(.year, from: $0.dateOfInfor) == year &&
            $0.spentOrGained && $0.name == "Food"
        }.reduce(0) { $0 + (Int($1.money) ?? 0) }
        XCTAssertEqual(totalFood, 10)
        
        // Percent
        let percentFood = spent == 0 ? 0 : Int(round((Double(totalFood) * 100.0) / Double(spent)))
        XCTAssertEqual(percentFood, 33) // 10 / 30 = 33.33%
    }
    
    // MARK: - Helpers
    private func makeInfo(name: String, money: String, spent: Bool, date: Date) throws {
        let ctx = InformationProvider.shared.viewContext
        let info = Information(context: ctx)
        info.name = name
        info.money = money
        info.spentOrGained = spent
        info.dateOfInfor = date
        info.userId = UserSession.shared.currentUserId
    }
}


