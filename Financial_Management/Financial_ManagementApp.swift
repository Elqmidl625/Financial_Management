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
                        // Reset UserDefaults
                        UserDefaults.standard.removeObject(forKey: "currentUserId")
                        UserDefaults.standard.removeObject(forKey: "savedAccounts")
                        UserDefaults.standard.set("default", forKey: "currentUserId")
                        UserSession.shared.currentUserId = "default"
                        UserSession.shared.savedAccounts = []
                        
                        // Wipe Core Data store (Users and Information)
                        let context = InformationProvider.shared.viewContext
                        do {
                            let infoFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Information")
                            let delInfo = NSBatchDeleteRequest(fetchRequest: infoFetch)
                            try context.execute(delInfo)
                            let userFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
                            let delUser = NSBatchDeleteRequest(fetchRequest: userFetch)
                            try context.execute(delUser)
                            try context.save()
                        } catch {
                            // Best-effort cleanup; tests may proceed even if not fully cleared
                            print("UI Test reset failed to wipe store: \(error)")
                        }
                    }
                    // Ensure there is always a current user id; create a default if missing
                    if UserDefaults.standard.string(forKey: "currentUserId") == nil {
                        UserDefaults.standard.set("default", forKey: "currentUserId")
                    }
                }
        }
    }
}
