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
    @State private var showInOutputSheet = false
    @State private var sheetDate = Date()
    
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
        .sheet(isPresented: $showInOutputSheet) {
            InputView(initialDate: sheetDate)
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
                        // compute month type and day for tap handling
                        let start = startingSpaces == -1 ? startingSpaces + 7 : startingSpaces
                        let isPrev = count <= start
                        let isNext = (count - start) > dayInMonth
                        let isCurrent = !isPrev && !isNext
                        let dayInt = isPrev ? (daysInPrevMonth + count - start) : (isNext ? (count - start - dayInMonth) : (count - start))
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
                                .onTapGesture {
                                    if isCurrent {
                                        var comps = Calendar.current.dateComponents([.year, .month], from: dateHolder.date)
                                        comps.day = dayInt
                                        if let selected = Calendar.current.date(from: comps) {
                                            dateHolder.selectedDate = selected
                                        }
                                    }
                                }
                                .onTapGesture(count: 2) {
                                    if isCurrent {
                                        var comps = Calendar.current.dateComponents([.year, .month], from: dateHolder.date)
                                        comps.day = dayInt
                                        if let selected = Calendar.current.date(from: comps) {
                                            dateHolder.selectedDate = selected
                                            sheetDate = selected
                                            showInOutputSheet = true
                                        }
                                    }
                                }
                                
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
                            .onTapGesture {
                                if isCurrent {
                                    var comps = Calendar.current.dateComponents([.year, .month], from: dateHolder.date)
                                    comps.day = dayInt
                                    if let selected = Calendar.current.date(from: comps) {
                                        dateHolder.selectedDate = selected
                                    }
                                }
                            }
                            .onTapGesture(count: 2) {
                                if isCurrent {
                                    var comps = Calendar.current.dateComponents([.year, .month], from: dateHolder.date)
                                    comps.day = dayInt
                                    if let selected = Calendar.current.date(from: comps) {
                                        dateHolder.selectedDate = selected
                                        sheetDate = selected
                                        showInOutputSheet = true
                                    }
                                }
                            }
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
