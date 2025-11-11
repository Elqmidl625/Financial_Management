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
    
    let count: Int
    let startingSpaces: Int
    let daysInMonth: Int
    let daysInPrevMonth: Int
    
    var body: some View {
        VStack (spacing: 0) {
            Text(monthStruct().day())
                .foregroundColor(textColor(type: monthStruct().monthType))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            Text(totalGained() != 0 ? "\(totalGained())": "")
                .font(.system(size: 10))
                .padding(.bottom, 5)
                .foregroundColor(.blue)
            
            Text(totalSpent() != 0 ? "\(totalSpent())": "")
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
    
    // Calculate total gained for the day
    func totalGained() -> Int {
        let day = monthStruct().dayInt
        let monthYearString = CalendarHelper().monthYearString(dateHolder.date)
        
        let filteredInfo = information.filter { info in
            let infoDay = Calendar.current.component(.day, from: info.dateOfInfor)
            let infoMonthYearString = CalendarHelper().monthYearString(info.dateOfInfor)
            let monthType = monthStruct().monthType
            return infoDay == day && infoMonthYearString == monthYearString && !info.spentOrGained && monthType == .Current
        }
        
        var total = 0
        for info in filteredInfo {
            if let moneyValue = Int(info.money) {
                total += moneyValue
            }
        }
        return total
    }
        
        // Calculate total spent for the day
    func totalSpent() -> Int {
        let day = monthStruct().dayInt
        let monthYearString = CalendarHelper().monthYearString(dateHolder.date)
        
        let filteredInfo = information.filter { info in
            let infoDay = Calendar.current.component(.day, from: info.dateOfInfor)
            let infoMonthYearString = CalendarHelper().monthYearString(info.dateOfInfor)
            let monthType = monthStruct().monthType
            return infoDay == day && infoMonthYearString == monthYearString && info.spentOrGained && monthType == .Current
        }
        
        var total = 0
        for info in filteredInfo {
            if let moneyValue = Int(info.money) {
                total += moneyValue
            }
        }
        return total
    }
    
}

struct CalendarCell_Previews: PreviewProvider {
    static var previews: some View{
        let dateHolder = DateHolder()
        CalendarCell(count: 1, startingSpaces: 1, daysInMonth: 1, daysInPrevMonth: 1)
            .environmentObject(dateHolder)
    }
}
