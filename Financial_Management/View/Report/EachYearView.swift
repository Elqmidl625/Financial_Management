//
//  EachYearView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 29/8/24.
//

import Foundation
import SwiftUI
import Charts

struct sumView: View {
    
    var text: String
    var number: Int
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.bold)
            
            Spacer()
            
            Text("\(number)$")
                .fontWeight(.bold)
        }
        .frame(height: 50)
        .padding(.horizontal)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}

struct EachYearView: View {
    
    @StateObject private var vm = EachYearViewModel()
    
    @State private var isSpentView = true
    
    @EnvironmentObject var dateHolder: DateHolder
    @FetchRequest(fetchRequest: Information.allForCurrentUser()) private var information
    
    var body: some View {
        VStack {
            YearScrollerView()
                .environmentObject(dateHolder)
                .padding(.bottom, 10)
            
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
                
                sumView(text: "Sum:", number: vm.spent)
                
                categoryListView(categories: MockData.categories, isSpent: true)
                
                
            } else {
                pieChartView(categories: MockData.categoriesGained, isSpent: false)
                
                sumView(text: "Sum:", number: vm.gained)
                
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
                                isMonthlyMode: false
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
                    .foregroundStyle(by: .value("Name", category.name))
                    .cornerRadius(5)
                }
            }
        }
    }
}

struct EachYearView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        EachYearView()
            .environmentObject(dateHolder)
    }
}

