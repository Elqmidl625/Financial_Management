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
    @StateObject private var session = UserSession.shared
    
    var body: some View {
        TabView {
            InOutputView()
                .tabItem {
                    Image(systemName: "square.and.pencil")
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
                    Image(systemName: "ellipsis.circle")
                    Text("More")
                }
        }
        .id(session.currentUserId)   // Recreate the view tree when switching users
    }
}


#Preview {
    ContentView().environment(\.managedObjectContext, InformationProvider.shared.viewContext)
}
