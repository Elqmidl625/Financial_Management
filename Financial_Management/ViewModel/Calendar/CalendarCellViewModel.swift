//
//  CalendarCellViewModel.swift
//  Financial_Management
//
//  Created to move day totals calculation out of CalendarCell.
//

import Foundation
import SwiftUI

final class CalendarCellViewModel {
    
    func totalForDay(information: FetchedResults<Information>, date: Date, day: Int, isSpent: Bool) -> Int {
        let calendar = Calendar.current
        let monthYearString = CalendarHelper().monthYearString(date)
        
        let filteredInfo = information.filter { info in
            let infoDay = calendar.component(.day, from: info.dateOfInfor)
            let infoMonthYearString = CalendarHelper().monthYearString(info.dateOfInfor)
            return infoDay == day && infoMonthYearString == monthYearString && (info.spentOrGained == isSpent)
        }
        
        var total = 0
        for info in filteredInfo {
            if let moneyValue = Int(info.money) {
                total += moneyValue
            }
        }
        return total
    }
}


