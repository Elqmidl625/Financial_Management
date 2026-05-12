//
//  Financial_ManagementApp.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 31/7/24.
//

import SwiftUI
import CoreData

@main
struct Financial_ManagementApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, InformationProvider.shared.viewContext)
                .onAppear {
                    // UI Tests can request a clean state
                    if CommandLine.arguments.contains("-uiTestReset") {
                        UserDefaults.standard.removeObject(forKey: "customCategories_default")
                        
                        // Wipe Core Data store.
                        let context = InformationProvider.shared.viewContext
                        do {
                            let infoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
                            let delInfo = NSBatchDeleteRequest(fetchRequest: infoFetch)
                            try context.execute(delInfo)
                            try context.save()
                        } catch {
                            // Best-effort cleanup; tests may proceed even if not fully cleared
                            print("UI Test reset failed to wipe store: \(error)")
                        }
                    }
                }
        }
    }
}
