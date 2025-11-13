//
//  MoreView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 29/8/24.
//

import SwiftUI

struct MoreView: View {
    @StateObject private var session = UserSession.shared
    var body: some View {
        VStack(spacing: 0) {
            Text("More")
                .font(.title)
                .fontWeight(.bold)
            
            List {
                Section("Accounts (Test)") {
                    HStack {
                        Image(systemName: "person")
                        Text("Current userId")
                        Spacer()
                        Text(session.currentUserId)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .minimumScaleFactor(0.7)
                    }
                    Button {
                        try? UserSession.shared.ensureUser(email: "alice@example.com", userName: "Alice")
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Use Alice")
                        }
                    }
                    Button {
                        try? UserSession.shared.ensureUser(email: "bob@example.com", userName: "Bob")
                    } label: {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Use Bob")
                        }
                    }
                }
                Section() {
                    HStack {
                        Image(systemName: "gearshape")
                        Text("Basic setting")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Section() {
                    HStack {
                        Image(systemName: "lock")
                        Text("Fixed costs and recurring income")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "paintpalette")
                        Text("Change theme color")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "dollarsign.arrow.circlepath")
                        Text("Change app icon")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Section() {
                    HStack {
                        Image(systemName: "chart.bar")
                        Text("Reports during the year")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "chart.pie")
                        Text("Categories report during the year")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "chart.bar")
                        Text("Full report")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "chart.pie")
                        Text("Full categories report")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        Text("Search for transactions")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                        Text("Report balance changes")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
                Section() {
                    HStack {
                        Image(systemName: "questionmark.bubble")
                        Text("Help")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    
                    HStack {
                        Image(systemName: "person.text.rectangle")
                        Text("Application information")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }
                
            }
        }
        
        
    }
}

#Preview {
    MoreView()
}
