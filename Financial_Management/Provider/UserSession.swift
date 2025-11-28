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
    private let savedAccountsKey = "savedAccounts"
    
    @Published var currentUserId: String {
        didSet {
            UserDefaults.standard.set(currentUserId, forKey: defaultsKey)
        }
    }
    @Published var savedAccounts: [String] {
        didSet {
            UserDefaults.standard.set(savedAccounts, forKey: savedAccountsKey)
        }
    }
    
    private init() {
        currentUserId = UserDefaults.standard.string(forKey: defaultsKey) ?? "default"
        savedAccounts = UserDefaults.standard.array(forKey: savedAccountsKey) as? [String] ?? []
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
    
    // MARK: - Auth helpers
    func userExists(email: String, provider: InformationProvider = .shared) throws -> Bool {
        let context = provider.viewContext
        return try context.fetch(User.byEmail(email)).first != nil
    }
    
    func login(email: String, password: String, provider: InformationProvider = .shared) throws -> Bool {
        let context = provider.viewContext
        guard let user = try context.fetch(User.byEmail(email)).first else {
            return false
        }
        guard user.password == password else {
            return false
        }
        setCurrentUser(email: user.email)
        return true
    }
    
    // MARK: - Saved accounts
    func saveAccount(email: String) {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if savedAccounts.contains(normalized) == false {
            savedAccounts.append(normalized)
        }
    }
    
    func removeSavedAccount(email: String) {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        savedAccounts.removeAll { $0 == normalized }
    }

    // MARK: - Create user without switching session
    func createUser(email: String,
                    userName: String,
                    password: String,
                    provider: InformationProvider = .shared) throws -> User {
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let context = provider.viewContext
        if let existing = try context.fetch(User.byEmail(normalized)).first {
            return existing
        }
        let user = User(context: context)
        user.email = normalized
        user.userName = userName
        user.password = password
        user.userId = Self.userId(from: normalized)
        try context.save()
        return user
    }

    // MARK: - Account deletion (requires password)
    enum AccountError: Error {
        case userNotFound
        case invalidPassword
    }
    
    func deleteAccount(email: String, password: String, provider: InformationProvider = .shared) throws {
        let context = provider.viewContext
        let normalized = email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard let user = try context.fetch(User.byEmail(normalized)).first else {
            throw AccountError.userNotFound
        }
        guard user.password == password else {
            throw AccountError.invalidPassword
        }
        
        // Delete user's transactions
        let uid = Self.userId(from: normalized)
        let infoRequest: NSFetchRequest<Information> = NSFetchRequest(entityName: "Information")
        infoRequest.predicate = NSPredicate(format: "userId == %@", uid)
        let infos = try context.fetch(infoRequest)
        infos.forEach { context.delete($0) }
        
        // Delete user
        context.delete(user)
        try context.save()
        
        // Remove from saved accounts and logout if current
        removeSavedAccount(email: normalized)
        if currentUserId == uid {
            currentUserId = "default"
        }
    }
}


