//
//  CalendarSummaryViewModel.swift
//  Financial_Management
//
//  Created to move calculation logic out of views.
//

import Foundation
import SwiftUI

final class CalendarSummaryViewModel: ObservableObject {
    
    @Published var totalGained: Int = 0
    @Published var totalSpent: Int = 0
    
    func recalculateTotals(information: FetchedResults<Information>, forMonthOf date: Date) {
        totalGained = 0
        totalSpent = 0
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        information.forEach { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if infoMonth == currentMonth && infoYear == currentYear {
                if info.spentOrGained {
                    totalSpent += (Int(info.money) ?? 0)
                } else {
                    totalGained += (Int(info.money) ?? 0)
                }
            }
        }
    }
    
    func groupedInformation(information: FetchedResults<Information>, forMonthOf date: Date) -> [(key: String, value: [Information])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: date)
        let currentYear = calendar.component(.year, from: date)
        
        let filteredAndSortedInformation = information.filter { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            return infoMonth == currentMonth && infoYear == currentYear
        }.sorted { $0.dateOfInfor > $1.dateOfInfor }
        
        var grouped: [(key: String, value: [Information])] = []
        
        for info in filteredAndSortedInformation {
            let dateString = formatter.string(from: info.dateOfInfor)
            
            if let index = grouped.firstIndex(where: { $0.key == dateString }) {
                grouped[index].value.append(info)
            } else {
                grouped.append((key: dateString, value: [info]))
            }
        }
        
        return grouped
    }
}


