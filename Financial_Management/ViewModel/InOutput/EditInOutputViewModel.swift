//
//  EditInOutputViewModel.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 5/8/24.
//

import Foundation
import CoreData

final class EditInOutputViewModel: ObservableObject {
    
    @Published var information: Information
    
    private let context: NSManagedObjectContext
    
    init(provider: InformationProvider, information: Information? = nil) {
        self.context = provider.newContext
        self.information = Information(context: self.context)
    }
    
    func save() throws {
        // Attach to current user before saving
        let currentId = UserDefaults.standard.string(forKey: "currentUserId") ?? "default"
        information.userId = currentId
        if context.hasChanges {
            try context.save()
        }
    }
    
    func startNewInformation(date: Date? = nil, spentOrGained: Bool? = nil) {
        let newInfo = Information(context: self.context)
        if let date {
            newInfo.dateOfInfor = date
        }
        if let spentOrGained {
            newInfo.spentOrGained = spentOrGained
        }
        self.information = newInfo
    }
}


