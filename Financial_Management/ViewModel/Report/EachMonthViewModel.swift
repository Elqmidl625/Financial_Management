//
//  EachMonthViewModel.swift
//  Financial_Management
//
//  Moves monthly report calculations out of the view.
//

import Foundation
import SwiftUI

final class EachMonthViewModel: ObservableObject {
    
    @Published var gained: Int = 0
    @Published var spent: Int = 0
    
    func recalculateTotals(information: FetchedResults<Information>, date: Date) {
        gained = 0
        spent = 0
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        information.forEach { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if infoMonth == currentMonth && infoYear == currentYear {
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
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        var total = 0
        
        information.forEach { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if infoMonth == currentMonth && infoYear == currentYear {
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


