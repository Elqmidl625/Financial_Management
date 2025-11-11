//
//  MonthStruct.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 3/8/24.
//

import Foundation
import SwiftUI

struct MonthStruct {
    var monthType: MonthType
    var dayInt: Int
    func day() -> String {
        return String(dayInt)
    }
}

enum MonthType {
    case Previous
    case Current
    case Next
}

