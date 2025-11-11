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
    
    var body: some View {
        HStack {
            HStack (spacing: 10) {
                Image(categories.imageName)
                    .resizable()
                    .frame(width: 30,
                           height: 30)
                
                Text(categories.name)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                
                Spacer()
                
                Text("\(money)$")
                    .fontWeight(.bold)
                
                Text("\(percent)%")
                    .font(.system(size: 12))
                
                Image(systemName: "chevron.right")
                
                
            }
        }
    }
}

#Preview {
    EachElementView(categories: MockData.sampleCate, money: 500000, percent: 50)
}
