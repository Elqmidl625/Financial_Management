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
        }
    }
}
