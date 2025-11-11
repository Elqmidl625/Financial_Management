//
//  EachYearViewModel.swift
//  Financial_Management
//
//  Moves yearly report calculations out of the view.
//

import Foundation
import SwiftUI

final class EachYearViewModel: ObservableObject {
    
    @Published var gained: Int = 0
    @Published var spent: Int = 0
    
    func recalculateTotals(information: FetchedResults<Information>, date: Date) {
        gained = 0
        spent = 0
        
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        
        information.forEach { info in
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if infoYear == currentYear {
                if info.spentOrGained {
                    spent += (Int(info.money) ?? 0)
                } else {
                    gained += (Int(info.money) ?? 0)
                }
            }
        }
    }
    
    func calculateTotalMoney(for category: Categories, information: FetchedResults<Information>, date: Date, isSpent: Bool) -> Int {
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: date)
        
        var total = 0
        
        information.forEach { info in
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if infoYear == currentYear {
                if info.spentOrGained == isSpent && info.name == category.name {
                    total += (Int(info.money) ?? 0)
                }
            }
        }
        
        return total
    }
    
    func calculatePercent(for category: Categories, information: FetchedResults<Information>, date: Date, isSpent: Bool) -> Int {
        let totalCategoryMoney = calculateTotalMoney(for: category, information: information, date: date, isSpent: isSpent)
        let totalMoney = isSpent ? spent : gained
        
        guard totalMoney > 0 else {
            return 0
        }
        
        let percentage = (Double(totalCategoryMoney) * 100.0) / Double(totalMoney)
        return Int(round(percentage))
    }
}


