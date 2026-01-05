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
    @ObservedObject private var currencyManager = CurrencyManager.shared
    
    var body: some View {
        HStack {
            Text(text)
            
            Spacer()
            
            Text(currencyManager.formatAmount(number))
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
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
    
    @StateObject private var vm = EachMonthViewModel()
    
    @State private var isSpentView = true
    @ObservedObject private var categoryManager = CustomCategoryManager.shared
    
    @EnvironmentObject var dateHolder: DateHolder
    @FetchRequest(fetchRequest: Information.allForCurrentUser()) private var information
    
    var body: some View {
        VStack {
            DateScrollerView()
                .environmentObject(dateHolder)
            
            HStack {
                threeRectangle(text: "Expense:", number: vm.spent, color: .red)
                threeRectangle(text: "Income:", number: vm.gained, color: .blue)
            }
            .padding(.horizontal, 5)
            
            let sum = vm.gained - vm.spent
            threeRectangle(text: "Total:", number: sum, color: (sum >= 0 ? .blue : .red))
                .padding(.horizontal, 5)
            
            HStack {
                Button(action: {
                    isSpentView = true
                }, label: {
                    if isSpentView {
                        VStack(spacing: 0) {
                            Text("Expense")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                            
                            Rectangle()
                                .frame(height: 3)
                                .cornerRadius(10)
                                .foregroundColor(.red)
                        }
                    } else {
                        VStack(spacing: 0) {
                            Text("Expense")
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
                            Text("Income")
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
                            Text("Income")
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
            vm.recalculateTotals(information: information, date: dateHolder.date)
        }
        .onChange(of: dateHolder.date){
            vm.recalculateTotals(information: information, date: dateHolder.date)
        }
        
    }
    
    // Calculate the total money of a category
    private func calculateTotalMoney(for category: Categories, isSpent: Bool) -> Int {
        vm.calculateTotalMoney(for: category, information: information, date: dateHolder.date, isSpent: isSpent)
    }
    
    // Calculate the percentage
    private func calculatePercent(for category: Categories, isSpent: Bool) -> Int {
        vm.calculatePercent(for: category, information: information, date: dateHolder.date, isSpent: isSpent)
    }
    
    // Show the list
    private func categoryListView(categories: [Categories], isSpent: Bool) -> some View {
        List {
            Section("Categories:") {
                ForEach(categories) { category in
                    let totalMoney = calculateTotalMoney(for: category, isSpent: isSpent)
                    let percent = calculatePercent(for: category, isSpent: isSpent)
                    if totalMoney > 0 {
                        NavigationLink {
                            CategoryBarChartView(
                                category: category,
                                isSpent: isSpent,
                                isMonthlyMode: true
                            )
                            .environmentObject(dateHolder)
                        } label: {
                            EachElementView(categories: category,
                                            money: totalMoney,
                                            percent: percent)
                        }
                    }
                }
            }
        }
    }
    
    private func pieChartView(categories: [Categories], isSpent: Bool) -> some View {
        Chart {
            ForEach(categories) { category in
                let amount = calculateTotalMoney(for: category, isSpent: isSpent)
                if amount > 0 {
                    SectorMark(angle: .value("Amount", amount), 
                               innerRadius: .ratio(0.5),
                               angularInset: 1)
                        .foregroundStyle(category.symbolColor)
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
    threeRectangle(text: "Expense:", number: 500000, color: .red)
}
