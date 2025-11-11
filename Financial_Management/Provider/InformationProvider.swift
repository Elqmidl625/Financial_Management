//
//  InformationProvider.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 5/8/24.
//

import Foundation
import CoreData
import SwiftUI

final class InformationProvider {
    
    static let shared = InformationProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Financial_Management")
//        if EnvironmentValues.isPreview {
//            persistentContainer.persistentStoreDescriptions.first?.url = .init(fileURLWithPath: "/dev/null")
//        }
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Unable to load store with error: \(error)")
            }
        }
    }
}

//extension EnvironmentValues {
//    static var isPreview: Bool {
//        return ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
//    }
//}
