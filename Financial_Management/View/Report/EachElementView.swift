//
//  EachElementView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 17/8/24.
//

import SwiftUI

struct EachElementView: View {
    
    let categories: Categories
    var money: Int
    var percent: Int
    @ObservedObject private var currencyManager = CurrencyManager.shared
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: categories.systemSymbolName)
                .font(.system(size: 25))
                .foregroundColor(categories.symbolColor)
                .frame(width: 30, height: 30)
            
            Text(categories.name)
                .font(.system(size: 15))
                .fontWeight(.bold)
            
            Spacer()
            
            Text(currencyManager.formatAmount(money))
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            
            Text("\(percent)%")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    EachElementView(categories: MockData.sampleCate, money: 500000, percent: 50)
}
