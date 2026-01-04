//
//  SpentGainedView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 5/8/24.
//

import SwiftUI

struct SpentGainedView: View {
    
//    @Environment(\.managedObjectContext) private var moc
    
    @ObservedObject var information: Information    // spent = true; gained = false
    
    var body: some View {
        
        
        HStack (spacing: 10) {
            Image(systemName: CategorySymbols.systemName(for: information.name))
                .font(.system(size: 25))
                .foregroundColor(CategorySymbols.color(for: information.name))
                .frame(width: 30, height: 30)
            
            Text(information.name)
                .font(.system(size: 15))
                .fontWeight(.bold)
            
            Text("(\(information.note))")
                .font(.system(size: 12))
            
            Spacer()
            
            let monInt = Int(information.money) ?? 0
            Text("\(monInt)$")
                .fontWeight(.bold)
                .foregroundColor(information.spentOrGained ? .red : .blue)
        }
    }
}

//#Preview {
//    SpentGainedView(information: <#Information#>)
//}
