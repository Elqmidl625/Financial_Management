//
//  EachMonthView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 15/8/24.
//

import SwiftUI
import Charts

struct threeRectangle: View {
    
    var text: String
    var number: Int
    var color: Color
    
    var body: some View {
        HStack {
            Text(text)
            
            Spacer()
            
            Text("\(number)$")
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(height: 50)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

struct EachMonthView: View {
    
    @State private var gained: Int = 0
    @State private var spent: Int = 0
    
    @State private var isSpentView = true
    
    @EnvironmentObject var dateHolder: DateHolder
    @FetchRequest(fetchRequest: Information.all()) private var information
    
    var body: some View {
        VStack {
            DateScrollerView()
                .environmentObject(dateHolder)
            
            HStack {
                threeRectangle(text: "Spent:", number: spent, color: .red)
                threeRectangle(text: "Gained:", number: gained, color: .blue)
            }
            .padding(.horizontal, 5)
            
            let sum = gained - spent
            threeRectangle(text: "Total:", number: sum, color: (sum >= 0 ? .blue : .red))
                .padding(.horizontal, 5)
            
            HStack {
                Button(action: {
                    isSpentView = true
                }, label: {
                    if isSpentView {
                        VStack(spacing: 0) {
                            Text("Spent")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Rectangle()
                                .frame(height: 3)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                        }
                    } else {
                        VStack(spacing: 0) {
                            Text("Spent")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .frame(height: 3)
                                .cornerRadius(10)
                                .foregroundColor(.gray)
                        }
                    }
                })
                
                Button(action: {
                    isSpentView = false
                }, label: {
                    if isSpentView == false {
                        VStack(spacing: 0) {
                            Text("Gained")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Rectangle()
                                .frame(height: 3)
                                .cornerRadius(10)
                                .foregroundColor(.blue)
                        }
                    } else {
                        VStack(spacing: 0) {
                            Text("Gained")
                                .font(.title2)
                                .foregroundColor(.gray)
                            
                            Rectangle()
                                .frame(height: 3)
                                .cornerRadius(10)
                                .foregroundColor(.gray)
                        }
                    }
                })
            }
            
            if isSpentView {
                pieChartView(categories: MockData.categories, isSpent: true)
                
                categoryListView(categories: MockData.categories, isSpent: true)
            } else {
                pieChartView(categories: MockData.categoriesGained, isSpent: false)
                
                categoryListView(categories: MockData.categoriesGained, isSpent: false)
            }
            
            
        }
        .onAppear() {
            recalculateTotals()
        }
        .onChange(of: dateHolder.date){
            recalculateTotals()
        }
        
    }
    
    private func recalculateTotals() {
        spent = 0
        gained = 0
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: dateHolder.date)
        let currentYear = calendar.component(.year, from: dateHolder.date)
        
        information.forEach { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            
            // Check if the information's month and year match the currently displayed month and year
            if infoMonth == currentMonth && infoYear == currentYear {
                if info.spentOrGained {
                    spent += (Int(info.money) ?? 0)
                } else {
                    gained += (Int(info.money) ?? 0)
                }
            }
        }
    }
    
    // Calculate the total money of a category
    private func calculateTotalMoney(for category: Categories, isSpent: Bool) -> Int {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: dateHolder.date)
        let currentYear = calendar.component(.year, from: dateHolder.date)
        
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
    
    // Calculate the percentage
    private func calculatePercent(for category: Categories, isSpent: Bool) -> Int {
        let totalCategoryMoney = calculateTotalMoney(for: category, isSpent: isSpent)
        let totalMoney = isSpent ? spent : gained
        
        guard totalMoney > 0 else {
            return 0
        }
        
        let percentage = (Double(totalCategoryMoney) * 100.0) / Double(totalMoney)
        return Int(round(percentage))
    }
    
    // Show the list
    private func categoryListView(categories: [Categories], isSpent: Bool) -> some View {
        List {
            Section("Categories:") {
                ForEach(categories) { category in
                    let totalMoney = calculateTotalMoney(for: category, isSpent: isSpent)
                    let percent = calculatePercent(for: category, isSpent: isSpent)
                    if percent != 0 {
                        EachElementView(categories: category,
                                        money: totalMoney,
                                        percent: percent)
                    }
                }
            }
        }
    }
    
    private func pieChartView(categories: [Categories], isSpent: Bool) -> some View {
        Chart {
            ForEach(categories) { category in
                let percent = calculatePercent(for: category, isSpent: isSpent)
                if percent != 0 {
                    SectorMark(angle: .value("Category", percent), 
                               innerRadius: .ratio(0.5),
                               angularInset: 1)
                        .foregroundStyle(by: .value("Name", category.name))
                        .cornerRadius(5)
                }
            }
        }
        
    }
    
}

struct EachMonthView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        EachMonthView()
            .environmentObject(dateHolder)
    }
}

#Preview {
    threeRectangle(text: "Spent:", number: 500000, color: .red)
}
