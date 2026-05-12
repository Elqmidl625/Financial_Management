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
        UserDefaults.standard.removeObject(forKey: "customCategories_default")
    }
    
    static func deleteAllEntities(file: StaticString = #file, line: UInt = #line) {
        let context = viewContext
        do {
            // Delete Informations
            let infoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
            let delInfo = NSBatchDeleteRequest(fetchRequest: infoFetch)
            try context.execute(delInfo)
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
