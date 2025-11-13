//
//  Financial_ManagementApp.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 31/7/24.
//

import SwiftUI

@main
struct Financial_ManagementApp: App {
//    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, InformationProvider.shared.viewContext)
                .onAppear {
                    // Ensure there is always a current user id; create a default if missing
                    if UserDefaults.standard.string(forKey: "currentUserId") == nil {
                        UserDefaults.standard.set("default", forKey: "currentUserId")
                    }
                }
        }
    }
}
