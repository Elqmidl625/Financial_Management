//
//  CustomCategory.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import Foundation
import SwiftUI
import CoreData
import UIKit

// Model for custom categories
struct CustomCategory: Codable, Identifiable, Hashable {
    var id: UUID
    var name: String
    var systemSymbolName: String
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var isIncome: Bool  // true for income, false for expense
    
    var color: Color {
        Color(red: colorRed, green: colorGreen, blue: colorBlue)
    }
    
    init(id: UUID = UUID(), name: String, systemSymbolName: String, color: Color, isIncome: Bool) {
        self.id = id
        self.name = name
        self.systemSymbolName = systemSymbolName
        self.isIncome = isIncome
        
        // Extract RGB components from Color
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        self.colorRed = Double(red)
        self.colorGreen = Double(green)
        self.colorBlue = Double(blue)
    }
}

// Manager for custom categories using UserDefaults (user-specific)
class CustomCategoryManager: ObservableObject {
    static let shared = CustomCategoryManager()
    
    @Published var customCategories: [CustomCategory] = []
    
    private var currentUserId: String {
        UserSession.shared.currentUserId
    }
    
    private func userDefaultsKey(for userId: String) -> String {
        "customCategories_\(userId)"
    }
    
    private init() {
        loadCustomCategories()
        // Observe user changes
        NotificationCenter.default.addObserver(
            forName: NSNotification.Name("UserDidChange"),
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.loadCustomCategories()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func loadCustomCategories() {
        let key = userDefaultsKey(for: currentUserId)
        if let data = UserDefaults.standard.data(forKey: key),
           let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
            customCategories = decoded
        } else {
            customCategories = []
        }
        objectWillChange.send()
    }
    
    func saveCustomCategories() {
        let key = userDefaultsKey(for: currentUserId)
        if let encoded = try? JSONEncoder().encode(customCategories) {
            UserDefaults.standard.set(encoded, forKey: key)
            objectWillChange.send()
        }
    }
    
    func addCustomCategory(_ category: CustomCategory) {
        customCategories.append(category)
        saveCustomCategories()
    }
    
    func updateCustomCategory(_ category: CustomCategory) {
        if let index = customCategories.firstIndex(where: { $0.id == category.id }) {
            customCategories[index] = category
            saveCustomCategories()
        }
    }
    
    func deleteCustomCategory(_ category: CustomCategory, provider: InformationProvider = .shared) throws {
        // Delete all transactions with this category name for current user
        let context = provider.viewContext
        let request: NSFetchRequest<Information> = NSFetchRequest(entityName: "Information")
        request.predicate = NSPredicate(format: "name == %@ AND userId == %@", category.name, currentUserId)
        
        let transactions = try context.fetch(request)
        transactions.forEach { context.delete($0) }
        
        // Delete the category
        customCategories.removeAll { $0.id == category.id }
        saveCustomCategories()
        
        // Save context
        if context.hasChanges {
            try context.save()
        }
    }
    
    func customCategoriesForType(isIncome: Bool) -> [CustomCategory] {
        customCategories.filter { $0.isIncome == isIncome }
    }
}

