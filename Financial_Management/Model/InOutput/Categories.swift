//
//  CategoriesViewModel.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import Foundation
import SwiftUI


struct Categories: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    
    // SF Symbol name and color for this category
    var systemSymbolName: String {
        CategorySymbols.systemName(for: name)
    }
    
    var symbolColor: Color {
        CategorySymbols.color(for: name)
    }
}

// Helper to map category names to SF Symbols and colors
struct CategorySymbols {
    static func systemName(for categoryName: String) -> String {
        // Check custom categories first
        if let customCategory = CustomCategoryManager.shared.customCategories.first(where: { $0.name == categoryName }) {
            return customCategory.systemSymbolName
        }
        
        // Default categories
        switch categoryName {
        // Expense categories
        case "Food": return "fork.knife"
        case "Shopping": return "bag"
        case "Clothes": return "tshirt"
        case "Coffee": return "cup.and.saucer"
        case "Medicine": return "pills"
        case "Education": return "book"
        case "Sport": return "figure.run"
        case "Travel": return "airplane"
        case "Contact fee": return "phone"
        case "House": return "house"
        case "Gift": return "gift"
        case "Trash": return "trash"
        
        // Income categories
        case "Salary": return "dollarsign.circle"
        case "Allowance": return "banknote"
        case "Bonus": return "star.circle"
        case "Overtime": return "clock"
        case "Invest": return "chart.line.uptrend.xyaxis"
        case "Temporary": return "briefcase"
        
        default: return "circle"
        }
    }
    
    static func color(for categoryName: String) -> Color {
        // Check custom categories first
        if let customCategory = CustomCategoryManager.shared.customCategories.first(where: { $0.name == categoryName }) {
            return customCategory.color
        }
        
        // Default categories
        switch categoryName {
        // Expense categories - various colors
        case "Food": return .orange
        case "Shopping": return Color(red: 1.0, green: 0.0, blue: 0.75)  // Magenta/Pink
        case "Clothes": return .purple
        case "Coffee": return .brown
        case "Medicine": return .red
        case "Education": return .blue
        case "Sport": return .green
        case "Travel": return .cyan
        case "Contact fee": return .indigo
        case "House": return .mint
        case "Gift": return Color(red: 1.0, green: 0.65, blue: 0.0)  // Orange/Coral
        case "Trash": return .gray
        
        // Income categories - blue/green tones
        case "Salary": return .blue
        case "Allowance": return .green
        case "Bonus": return .yellow
        case "Overtime": return .orange
        case "Invest": return .mint
        case "Temporary": return .teal
        
        default: return .primary
        }
    }
}

struct MockData {
    
    static let sampleCate = Categories(name: "Food",
                                           imageName: "food")
    
    static var categories: [Categories] {
        let defaultCategories = [
        Categories(name: "Food",
                  imageName: "food"),
        
        Categories(name: "Shopping",
                  imageName: "shopping"),
        
        Categories(name: "Clothes",
                  imageName: "clothes"),
        
        Categories(name: "Coffee",
                  imageName: "coffee"),
        
        Categories(name: "Medicine",
                  imageName: "medicine"),

        Categories(name: "Education",
                  imageName: "education"),
        
        Categories(name: "Sport",
                  imageName: "sport"),
        
        Categories(name: "Travel",
                  imageName: "travel"),
        
        Categories(name: "Contact fee",
                  imageName: "contact_fee"),
        
        Categories(name: "House",
                  imageName: "house"),
        
        Categories(name: "Gift",
                  imageName: "gift"),
        
        Categories(name: "Trash",
                  imageName: "trash"),
    ]
    
        // Add custom expense categories
        let customExpenseCategories = CustomCategoryManager.shared.customCategoriesForType(isIncome: false).map { custom in
            Categories(name: custom.name, imageName: custom.name.lowercased())
        }
        
        return defaultCategories + customExpenseCategories
    }
    
    static var categoriesGained: [Categories] {
        let defaultCategories = [
            Categories(name: "Salary",
                      imageName: "salary"),
        
        Categories(name: "Allowance",
                  imageName: "allowance"),
        
        Categories(name: "Bonus",
                  imageName: "bonus"),
        
        Categories(name: "Overtime",
                  imageName: "overtime"),
        
        Categories(name: "Invest",
                  imageName: "invest"),

        Categories(name: "Temporary",
                  imageName: "temporary"),
    ]
        
        // Add custom income categories
        let customIncomeCategories = CustomCategoryManager.shared.customCategoriesForType(isIncome: true).map { custom in
            Categories(name: custom.name, imageName: custom.name.lowercased())
        }
        
        return defaultCategories + customIncomeCategories
    }
}
