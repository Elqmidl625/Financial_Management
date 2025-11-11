//
//  CalendarCell.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 3/8/24.
//

import SwiftUI

struct CalendarCell: View {
    
    @EnvironmentObject var dateHolder: DateHolder
    @FetchRequest(fetchRequest: Information.all()) private var information
    private let vm = CalendarCellViewModel()
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    var body: some View {
        VStack (spacing: 0) {
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(vm.totalForDay(information: information, date: dateHolder.date, day: monthStruct().dayInt, isSpent: false) != 0 ? "\(vm.totalForDay(information: information, date: dateHolder.date, day: monthStruct().dayInt, isSpent: false))": "")
                .font(.system(size: 10))
                .padding(.bottom, 5)
                .foregroundColor(.blue)
            
            Text(vm.totalForDay(information: information, date: dateHolder.date, day: monthStruct().dayInt, isSpent: true) != 0 ? "\(vm.totalForDay(information: information, date: dateHolder.date, day: monthStruct().dayInt, isSpent: true))": "")
                .font(.system(size: 10))
                .padding(.bottom, 5)
                .foregroundColor(.red)
        }
    }
    
    func textColor(type: MonthType) -> Color {
        return type == MonthType.Current ? Color.white : Color.gray
    }
    
    func monthStruct() -> MonthStruct {
        let start = startingSpaces == -1 ? startingSpaces + 7 : startingSpaces
        if(count <= start) {
            let day = daysInPrevMonth + count - start
            return MonthStruct(monthType: MonthType.Previous, dayInt: day)
        }
        
        else if(count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return MonthStruct(monthType: MonthType.Next, dayInt: day)
        }
        
        let day = count - start
        return MonthStruct(monthType: MonthType.Current, dayInt: day)
    }
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
            .environmentObject(dateHolder)
    }
}
