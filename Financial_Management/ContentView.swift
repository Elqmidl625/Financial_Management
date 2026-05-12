//
//  ContentView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 31/7/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    let dateHolder = DateHolder()
    
    var body: some View {
        TabView {
            InputView()
                .tabItem {
                    Image(systemName: "note.text")
                    Text("Input")
                }
            
            CalendarView()
                .environmentObject(dateHolder)
                .tabItem {
                    Image(systemName: "calendar.badge.clock")
                    Text("Calendar")
                }
            
            ReportView()
                .environmentObject(dateHolder)
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("Report")
                }
            
            MoreView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("More")
                }
        }
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, InformationProvider.shared.viewContext)
}
