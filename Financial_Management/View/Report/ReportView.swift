//
//  ReportView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 15/8/24.
//

import SwiftUI

struct ReportView: View {
    
    @State var isEachMonth = true
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack {
                    Group {
                        if #available(iOS 26.0, *) {
                            GlassEffectContainer {
                                Picker("", selection: $isEachMonth) {
                                    Text("Each month").tag(true)
                                    Text("Each year").tag(false)
                                }
                                .pickerStyle(.segmented)
                                .controlSize(.large)
                                .font(.headline)
                                .padding(.horizontal, 12)
                                .frame(width: 300)
                            }
                        } else {
                            Picker("", selection: $isEachMonth) {
                                Text("Each month").tag(true)
                                Text("Each year").tag(false)
                            }
                            .pickerStyle(.segmented)
                            .controlSize(.large)
                            .font(.headline)
                            .padding(.horizontal, 12)
                        }
                    }
                    .frame(width: geometry.size.width, height: 64)
                    .padding(.vertical)
                    
                    if isEachMonth {
                        EachMonthView()
                            .environmentObject(dateHolder)
                    } else {
                        EachYearView()
                            .environmentObject(dateHolder)
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Report")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ReportView()
        .environmentObject(DateHolder())
}
