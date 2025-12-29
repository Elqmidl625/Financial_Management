//
//  CategoryBarChartViewModel.swift
//  Financial_Management
//
//  Created for category bar chart statistics.
//

import Foundation
import SwiftUI

struct CategoryChartData: Identifiable {
    let id = UUID()
    let label: String       // Month name or year
    let amount: Int
    let date: Date          // Used for sorting
}

final class CategoryBarChartViewModel: ObservableObject {
    
    @Published var chartData: [CategoryChartData] = []
    
    /// Calculate monthly data for a category (shows data for each month of the selected year)
    func calculateMonthlyData(
        for category: Categories,
        information: FetchedResults<Information>,
        year: Int,
        isSpent: Bool
    ) {
        var monthlyData: [CategoryChartData] = []
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM"
        
        // Iterate through all 12 months
        for month in 1...12 {
            var total = 0
            
            // Calculate total for this month
            information.forEach { info in
                let infoMonth = calendar.component(.month, from: info.dateOfInfor)
                let infoYear = calendar.component(.year, from: info.dateOfInfor)
                
                if infoMonth == month && infoYear == year {
                    if info.spentOrGained == isSpent && info.name == category.name {
                        total += (Int(info.money) ?? 0)
                    }
                }
            }
            
            // Create a date for this month (for sorting and label)
            var components = DateComponents()
            components.year = year
            components.month = month
            components.day = 1
            
            if let date = calendar.date(from: components) {
                let monthLabel = dateFormatter.string(from: date)
                monthlyData.append(CategoryChartData(
                    label: monthLabel,
                    amount: total,
                    date: date
                ))
            }
        }
        
        // Sort by date
        chartData = monthlyData.sorted { $0.date < $1.date }
    }
    
    /// Calculate yearly data for a category (shows data for each year that has records)
    func calculateYearlyData(
        for category: Categories,
        information: FetchedResults<Information>,
        isSpent: Bool
    ) {
        var yearlyTotals: [Int: Int] = [:]
        let calendar = Calendar.current
        
        // Find all years and calculate totals
        information.forEach { info in
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            if info.spentOrGained == isSpent && info.name == category.name {
                let amount = Int(info.money) ?? 0
                yearlyTotals[infoYear, default: 0] += amount
            }
        }
        
        // If no data, show recent 5 years
        if yearlyTotals.isEmpty {
            let currentYear = calendar.component(.year, from: Date())
            for year in (currentYear - 4)...currentYear {
                yearlyTotals[year] = 0
            }
        }
        
        // Convert to chart data
        var yearlyData: [CategoryChartData] = []
        for (year, total) in yearlyTotals {
            var components = DateComponents()
            components.year = year
            components.month = 1
            components.day = 1
            
            if let date = calendar.date(from: components) {
                yearlyData.append(CategoryChartData(
                    label: "\(year)",
                    amount: total,
                    date: date
                ))
            }
        }
        
        // Sort by year
        chartData = yearlyData.sorted { $0.date < $1.date }
    }
    
    /// Get the maximum amount for Y-axis scaling
    var maxAmount: Int {
        chartData.map { $0.amount }.max() ?? 100
    }
    
    /// Get total amount
    var totalAmount: Int {
        chartData.reduce(0) { $0 + $1.amount }
    }
    
    /// Get average amount
    var averageAmount: Int {
        guard !chartData.isEmpty else { return 0 }
        let nonZeroData = chartData.filter { $0.amount > 0 }
        guard !nonZeroData.isEmpty else { return 0 }
        return nonZeroData.reduce(0) { $0 + $1.amount } / nonZeroData.count
    }
}

