//
//  CustomCategory.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import Foundation
import SwiftUI

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

// Manager for custom categories using UserDefaults
class CustomCategoryManager: ObservableObject {
    static let shared = CustomCategoryManager()
    
    @Published var customCategories: [CustomCategory] = []
    
    private let userDefaultsKey = "customCategories"
    
    private init() {
        loadCustomCategories()
    }
    
    func loadCustomCategories() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([CustomCategory].self, from: data) {
            customCategories = decoded
        }
    }
    
    func saveCustomCategories() {
        if let encoded = try? JSONEncoder().encode(customCategories) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
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
    
    func deleteCustomCategory(_ category: CustomCategory) {
        customCategories.removeAll { $0.id == category.id }
        saveCustomCategories()
    }
    
    func customCategoriesForType(isIncome: Bool) -> [CustomCategory] {
        customCategories.filter { $0.isIncome == isIncome }
    }
}

