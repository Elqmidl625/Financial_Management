//
//  CalendarView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//
// Cre: https://www.youtube.com/watch?v=jBvkFKhnYLI

import SwiftUI

struct CalendarView: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    
    var body: some View {
        VStack {
            Text("Calendar")
                .font(.system(size: 24))
                .fontWeight(.bold)
            
            DateScrollerView()
                .environmentObject(dateHolder)
            
            dayOfWeekStack
            CalendarGrid
            SpentGaindListView()
            
            
            // Add here
        }
    }
    
    var dayOfWeekStack: some View {
        HStack {
            Text("Mon").dayOfWeek()
            Text("Tue").dayOfWeek()
            Text("Wed").dayOfWeek()
            Text("Thur").dayOfWeek()
            Text("Fri").dayOfWeek()
            Text("Sat").dayOfWeek()
            Text("Sun").dayOfWeek()
        }
    }
    
    var CalendarGrid: some View {
        
        VStack (spacing: 1) {
            
            let dayInMonth = CalendarHelper().dayInMonth(dateHolder.date)
            let firstDayOfMonth = CalendarHelper().firstOfMonth(dateHolder.date)
            let startingSpaces = CalendarHelper().weekDay(firstDayOfMonth)
            let prevMonth = CalendarHelper().minusMonth(dateHolder.date)
            let daysInPrevMonth = CalendarHelper().dayInMonth(prevMonth)
            
            ForEach(0..<5) { row in
                HStack (spacing: 1){
                    ForEach(1..<8) { column in
                        let count = column + row * 7
                        if CalendarHelper().isTodayOnCalendar(count: count,
                                                              startingSpaces: startingSpaces,
                                                              daysInMonth: dayInMonth,
                                                              daysInPrevMonth: daysInPrevMonth, 
                                                              monthYearString: CalendarHelper().monthYearString(dateHolder.date)) {
                            ZStack {
                                CalendarCell(count: count,
                                             startingSpaces: startingSpaces,
                                             daysInMonth: dayInMonth,
                                             daysInPrevMonth: daysInPrevMonth)
                                .environmentObject(dateHolder)
                                
                                Rectangle()
                                    .foregroundColor(.gray)
                                    .opacity(0.3)
                                    .cornerRadius(5)
                            }
                            
                        } else {
                            CalendarCell(count: count,
                                         startingSpaces: startingSpaces,
                                         daysInMonth: dayInMonth,
                                         daysInPrevMonth: daysInPrevMonth)
                            .environmentObject(dateHolder)
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

extension Text {
    func dayOfWeek() -> some View {
        self.frame(maxWidth: .infinity)
            .fontWeight(.bold)
            .padding(.top, 1)
            .lineLimit(1)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        CalendarView()
            .environmentObject(dateHolder)
    }
}
