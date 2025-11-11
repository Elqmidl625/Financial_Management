//
//  YearScrollerView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 29/8/24.
//

import SwiftUI

struct YearScrollerView: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        HStack {
            Spacer()
            
            Button(action: previousYear) {
                Image(systemName: "arrow.left")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            
            Text(CalendarHelper().yearString(dateHolder.date))
                .font(.title)
                .bold()
                .animation(.none)
                .frame(maxWidth: .infinity)
            
            Button(action: nextYear) {
                Image(systemName: "arrow.right")
                    .imageScale(.large)
                    .font(Font.title.weight(.bold))
            }
            
            Spacer()
        }
    }
    
    func previousYear() {
        dateHolder.date = CalendarHelper().minusYear(dateHolder.date)
    }
    
    func nextYear() {
        dateHolder.date = CalendarHelper().plusYear(dateHolder.date)
    }
}

struct YearScrollerView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        YearScrollerView()
            .environmentObject(dateHolder)
    }
}
