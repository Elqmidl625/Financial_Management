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
        GeometryReader { geometry in
            VStack {
                HStack (spacing: 15) {
                    Button (action: {
                        isEachMonth = true
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(8)
                                .overlay(
                                    isEachMonth ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2) : RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0)
                                )
                            Text("Each month")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 30)
                    })
                    
                    Button (action: {
                        isEachMonth = false
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(8)
                                .overlay(
                                    isEachMonth ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0) : RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            Text("Each year")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 30)
                    })
                }
                .frame(width: geometry.size.width,
                       height: 35)
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
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        ReportView()
            .environmentObject(dateHolder)
    }
}
