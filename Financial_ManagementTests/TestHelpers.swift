//
//  TestHelpers.swift
//  Financial_ManagementTests
//
//  Shared helpers for unit tests.
//

import Foundation
import CoreData
import XCTest
@testable import Financial_Management

enum TestHelper {
    
    static var viewContext: NSManagedObjectContext {
        InformationProvider.shared.viewContext
    }
    
    static func resetUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.removeObject(forKey: "savedAccounts")
        UserDefaults.standard.set("default", forKey: "currentUserId")
        UserSession.shared.currentUserId = "default"
        UserSession.shared.savedAccounts = []
    }
    
    static func deleteAllEntities(file: StaticString = #file, line: UInt = #line) {
        let context = viewContext
        do {
            // Delete Informations
            let infoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            let delInfo = NSBatchDeleteRequest(fetchRequest: infoFetch)
            try context.execute(delInfo)
            // Delete Users
            let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
            let delUser = NSBatchDeleteRequest(fetchRequest: userFetch)
            try context.execute(delUser)
            try context.save()
        } catch {
            XCTFail("Failed to cleanup Core Data store: \(error)", file: file, line: line)
        }
    }
}

extension XCTestCase {
    func waitForCoreDataPropagation(seconds: TimeInterval = 0.2) {
        let until = Date().addingTimeInterval(seconds)
        RunLoop.current.run(until: until)
    }
}


