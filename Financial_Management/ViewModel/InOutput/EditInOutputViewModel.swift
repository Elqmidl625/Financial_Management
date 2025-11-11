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
        if context.hasChanges {
            try context.save()
        }
    }
}


