//
//  CategoryBarChartView.swift
//  Financial_Management
//
//  Bar chart view for category statistics over time.
//

import SwiftUI
import Charts

struct CategoryBarChartView: View {
    
    let category: Categories
    let isSpent: Bool
    let isMonthlyMode: Bool  // true = show monthly data, false = show yearly data
    
    @StateObject private var vm = CategoryBarChartViewModel()
    @EnvironmentObject var dateHolder: DateHolder
    @FetchRequest(fetchRequest: Information.allForCurrentUser()) private var information
    @ObservedObject private var currencyManager = CurrencyManager.shared
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Category header
                categoryHeader
                
                // Stats summary
                statsSummary
                
                // Bar chart
                barChartSection
                
                // Data table
                dataTable
            }
            .padding()
        }
        .navigationTitle(category.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadData()
        }
        .onChange(of: dateHolder.date) {
            loadData()
        }
    }
    
    // MARK: - Category Header
    private var categoryHeader: some View {
        HStack(spacing: 15) {
            Image(systemName: category.systemSymbolName)
                .font(.system(size: 40))
                .foregroundColor(category.symbolColor)
                .frame(width: 50, height: 50)
                .background(category.symbolColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(isSpent ? "Expense Analysis" : "Income Analysis")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Type indicator
            Text(isSpent ? "Expense" : "Income")
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSpent ? Color.red.opacity(0.2) : Color.blue.opacity(0.2))
                .foregroundColor(isSpent ? .red : .blue)
                .clipShape(Capsule())
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    // MARK: - Stats Summary
    private var statsSummary: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Total",
                value: currencyManager.formatAmount(vm.totalAmount),
                color: isSpent ? .red : .blue
            )
            
            StatCard(
                title: "Average",
                value: currencyManager.formatAmount(vm.averageAmount),
                color: .blue
            )
            
            StatCard(
                title: "Peak",
                value: currencyManager.formatAmount(vm.maxAmount),
                color: .orange
            )
        }
    }
    
    // MARK: - Helper Properties
    private var currentYearString: String {
        String(Calendar.current.component(.year, from: dateHolder.date))
    }
    
    // MARK: - Bar Chart Section
    private var barChartSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(isMonthlyMode ? "Monthly Breakdown (\(currentYearString))" : "Yearly Breakdown")
                .font(.headline)
                .padding(.horizontal)
            
            if vm.chartData.isEmpty || vm.totalAmount == 0 {
                emptyChartPlaceholder
            } else {
                barChart
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var barChart: some View {
        Chart(vm.chartData) { item in
            BarMark(
                x: .value("Period", item.label),
                y: .value("Amount", item.amount)
            )
            .foregroundStyle(
                LinearGradient(
                    colors: isSpent ? [.red.opacity(0.7), .red] : [.blue.opacity(0.7), .blue],
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
            .cornerRadius(6)
            .annotation(position: .top, alignment: .center) {
                if item.amount > 0 {
                    Text("\(item.amount)")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                AxisGridLine()
                AxisValueLabel {
                    if let intValue = value.as(Int.self) {
                        Text(currencyManager.formatAmount(intValue))
                            .font(.caption)
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let label = value.as(String.self) {
                        Text(label)
                            .font(.caption)
                    }
                }
            }
        }
        .frame(height: 250)
        .padding(.horizontal)
    }
    
    private var emptyChartPlaceholder: some View {
        VStack(spacing: 10) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 50))
                .foregroundColor(.secondary)
            
            Text("No data available")
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text("Start tracking your \(isSpent ? "expenses" : "income") in this category")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Data Table
    private var dataTable: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Details")
                .font(.headline)
            
            ForEach(vm.chartData) { item in
                HStack {
                    Text(item.label)
                        .font(.subheadline)
                    
                    Spacer()
                    
                    // Progress bar
                    GeometryReader { geometry in
                        let maxAmount = vm.maxAmount > 0 ? vm.maxAmount : 1
                        let width = geometry.size.width * CGFloat(item.amount) / CGFloat(maxAmount)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .frame(height: 8)
                                .clipShape(Capsule())
                            
                            Rectangle()
                                .fill(isSpent ? Color.red : Color.blue)
                                .frame(width: max(0, width), height: 8)
                                .clipShape(Capsule())
                        }
                    }
                    .frame(width: 100, height: 8)
                    
                    Text(currencyManager.formatAmount(item.amount))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .frame(width: 80, alignment: .trailing)
                }
                .padding(.vertical, 4)
                
                if item.id != vm.chartData.last?.id {
                    Divider()
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 15))
    }
    
    private var currentYear: Int {
        Calendar.current.component(.year, from: dateHolder.date)
    }
    
    // MARK: - Data Loading
    private func loadData() {
        if isMonthlyMode {
            vm.calculateMonthlyData(
                for: category,
                information: information,
                year: currentYear,
                isSpent: isSpent
            )
        } else {
            vm.calculateYearlyData(
                for: category,
                information: information,
                isSpent: isSpent
            )
        }
    }
}

// MARK: - StatCard Component
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 5) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        CategoryBarChartView(
            category: MockData.sampleCate,
            isSpent: true,
            isMonthlyMode: true
        )
        .environmentObject(DateHolder())
    }
}

