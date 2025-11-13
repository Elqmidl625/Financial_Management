//
//  User.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import Foundation
import CoreData

final class User: NSManagedObject, Identifiable {
    
    @NSManaged var email: String
    @NSManaged var userName: String
    @NSManaged var password: String
    @NSManaged var userId: String
    
    override func awakeFromInsert() {
        super.awakeFromInsert()
        // Ensure fields are initialized to safe defaults
        setPrimitiveValue("", forKey: "email")
        setPrimitiveValue("", forKey: "userName")
        setPrimitiveValue("", forKey: "password")
        setPrimitiveValue("", forKey: "userId")
    }
}

extension User {
    private static var userFetchRequest: NSFetchRequest<User> {
        NSFetchRequest(entityName: "User")
    }
    
    static func byEmail(_ email: String) -> NSFetchRequest<User> {
        let request: NSFetchRequest<User> = userFetchRequest
        request.predicate = NSPredicate(format: "email ==[c] %@", email)
        request.fetchLimit = 1
        return request
    }
}


