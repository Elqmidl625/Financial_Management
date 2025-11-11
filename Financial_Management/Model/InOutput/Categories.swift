//
//  CategoriesViewModel.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import Foundation


struct Categories: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

struct MockData {
    
    static let sampleCate = Categories(name: "Food",
                                           imageName: "food")
    
    static let categories = [
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
    
    static let categoriesGained = [
        Categories(name: "Sallary",
                  imageName: "sallary"),
        
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
}
