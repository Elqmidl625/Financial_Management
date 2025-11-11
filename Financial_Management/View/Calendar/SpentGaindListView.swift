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
    
    @StateObject private var vm = CalendarSummaryViewModel()
    
    @FetchRequest(fetchRequest: Information.all()) private var information
    
    var provider = InformationProvider.shared
    @EnvironmentObject var dateHolder: DateHolder
    
    
    var body: some View {
        VStack {
            let sum = vm.totalGained - vm.totalSpent
            
            HStack (spacing: 0) {
                SumbarView(content: "Gained", number: vm.totalGained, color: .blue)
                SumbarView(content: "Spent", number: vm.totalSpent, color: .red)
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
                ForEach(vm.groupedInformation(information: information, forMonthOf: dateHolder.date), id: \.key) { date, infos in
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
            vm.recalculateTotals(information: information, forMonthOf: dateHolder.date)
        }
        .onChange(of: dateHolder.date){
            vm.recalculateTotals(information: information, forMonthOf: dateHolder.date)
        }
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
                vm.recalculateTotals(information: self.information, forMonthOf: dateHolder.date)
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
