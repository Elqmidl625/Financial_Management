//
//  SpentGaindListView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 4/8/24.
//

import SwiftUI

struct SumbarView: View {
    
    var content: String
    var number: Int
    var color: Color
    
    var body: some View {
        VStack {
            Text(content)
                .font(.system(size: 14))
                .fontWeight(.bold)
            
            Text("\(number)$")
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
        }
        .frame(width: 130)
    }
}



struct SpentGaindListView: View {
    
    @State private var gained: Int = 0
    @State private var spent: Int = 0
    
    @FetchRequest(fetchRequest: Information.all()) private var information
    
    var provider = InformationProvider.shared
    @EnvironmentObject var dateHolder: DateHolder
    
    
    var body: some View {
        VStack {
            let sum = gained - spent
            
            HStack (spacing: 0) {
                SumbarView(content: "Gained", number: gained, color: .blue)
                SumbarView(content: "Spent", number: spent, color: .red)
                SumbarView(content: "Sum", number: sum, color: (sum >= 0 ? .blue : .red))
            }
            .frame(maxWidth: .infinity)
            .padding(8)
            .overlay(
                VStack {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.blue)
                    Spacer()
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(.blue)
                }
            )
            
            List {
                ForEach(groupedInformation(), id: \.key) { date, infos in
                    Section(header: Text(date)) {
                        ForEach(infos) { info in
                            SpentGainedView(information: info)
                                .swipeActions(allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        do {
                                            try delete(info)
                                        } catch {
                                            print(error)
                                        }
                                    } label: {
                                        Label("", systemImage: "trash")
                                    }
                                    .tint(.red)
                                }
                        }
                    }
                }
            }
        }
        .onAppear() {
            recalculateTotals()
        }
        .onChange(of: dateHolder.date){
            recalculateTotals()
        }
    }
    
    // Calculation the numbers in sumbar
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
    
    // Need to learn more about this function:
    // This func return to all days and infors of each day
    private func groupedInformation() -> [(key: String, value: [Information])] {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: dateHolder.date)
        let currentYear = calendar.component(.year, from: dateHolder.date)
        
        // Filter and sort the information array for the currently displayed month
        let filteredAndSortedInformation = information.filter { info in
            let infoMonth = calendar.component(.month, from: info.dateOfInfor)
            let infoYear = calendar.component(.year, from: info.dateOfInfor)
            return infoMonth == currentMonth && infoYear == currentYear
        }.sorted { $0.dateOfInfor > $1.dateOfInfor }
        
        // Group the filtered and sorted information by the formatted date string
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

// Delete information
private extension SpentGaindListView {
    func delete(_ information: Information) throws {
        let context = provider.viewContext
        let existingInformation = try context.existingObject(with: information.objectID)
        context.delete(existingInformation)
        Task(priority: .background) {
            try await context.perform {
                try context.save()
                recalculateTotals()
            }
        }
    }
}

struct SpentGaindListView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        SpentGaindListView()
            .environmentObject(dateHolder)
    }
}
