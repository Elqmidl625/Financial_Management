//
//  UserSession.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import Foundation
import CoreData

final class UserSession: ObservableObject {
    
    static let shared = UserSession()
    
    private let defaultsKey = "currentUserId"
    
    @Published var currentUserId: String {
        didSet {
            UserDefaults.standard.set(currentUserId, forKey: defaultsKey)
        }
    }
    
    private init() {
        currentUserId = UserDefaults.standard.string(forKey: defaultsKey) ?? "default"
    }
    
    func setCurrentUser(email: String) {
        let id = Self.userId(from: email)
        currentUserId = id
    }
    
    static func userId(from email: String) -> String {
        return email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }
    
    // Helper to create or fetch a user and set session
    func ensureUser(email: String,
                    userName: String? = nil,
                    password: String? = nil,
                    provider: InformationProvider = .shared) throws -> User {
        let context = provider.viewContext
        if let existing = try context.fetch(User.byEmail(email)).first {
            setCurrentUser(email: existing.email)
            return existing
        }
        
        let user = User(context: context)
        user.email = email
        user.userName = userName ?? ""
        user.password = password ?? ""
        user.userId = Self.userId(from: email)
        try context.save()
        setCurrentUser(email: email)
        return user
    }
}


