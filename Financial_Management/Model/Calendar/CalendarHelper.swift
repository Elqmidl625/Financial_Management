//
//  CalendarHelper.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import Foundation

class CalendarHelper {
    let calendar = Calendar.current
    let dateFormatter = DateFormatter()
    
    func monthYearString(_ date: Date) -> String {
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: date)
    }
    
    func yearString(_ date: Date) -> String {
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    func plusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    func minusMonth(_ date: Date) -> Date {
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    func plusYear(_ date: Date) -> Date {
        return calendar.date(byAdding: .year, value: 1, to: date)!
    }
    
    func minusYear(_ date: Date) -> Date {
        return calendar.date(byAdding: .year, value: -1, to: date)!
    }
    
    func dayInMonth(_ date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    func dayOfMonth(_ date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    func firstOfMonth(_ date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    func weekDay(_ date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 2      // Mon = 0; Tue = 1; wed = 2; ...
    }
    
    func getCurrentDay() -> Int {
        let currentDate = Date()
        let day = calendar.component(.day, from: currentDate) // Get day of the month
        return day
    }
    
    func getCurrentMonthAndYear() -> String {
        let currentDate = Date()
        dateFormatter.dateFormat = "LLL yyyy"
        return dateFormatter.string(from: currentDate) // Get month and year
    }

    
    func getDayOnCalendar(count: Int, startingSpaces: Int, daysInMonth: Int ,daysInPrevMonth: Int) -> Int {
        let start = startingSpaces == -1 ? startingSpaces + 7 : startingSpaces
        if(count <= start) {
            let day = daysInPrevMonth + count - start
            return day
        }
        
        else if(count - start > daysInMonth) {
            let day = count - start - daysInMonth
            return day
        }
        
        let day = count - start
        return day
    }
    
    func isTodayOnCalendar(count: Int, startingSpaces: Int, daysInMonth: Int ,daysInPrevMonth: Int, monthYearString: String) -> Bool {
        let start = startingSpaces == -1 ? startingSpaces + 7 : startingSpaces
        if getDayOnCalendar(count: count,
                              startingSpaces: startingSpaces,
                              daysInMonth: daysInMonth,
                              daysInPrevMonth: daysInPrevMonth) == getCurrentDay() && 
            getCurrentMonthAndYear() == monthYearString && count > start && count - start <= daysInMonth {
            return true
        }
        
        return false
    }
}
