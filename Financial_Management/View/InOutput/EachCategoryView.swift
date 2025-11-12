//
//  EachCategoryView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import SwiftUI


struct EachCategoryView: View {
    
    let categories: Categories
    @Binding var Selected: Int
    
    
    var body: some View {
        if Selected == categories.id.hashValue {
            ButtonCustom(imageName: categories.imageName,
                         name: categories.name,
                         textColor: true)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.blue, lineWidth: 2)
            )
            
        } else {
            ButtonCustom(imageName: categories.imageName,
                         name: categories.name,
                         textColor: false)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 1)
            )
        }
    }
}


struct ButtonCustom: View {
    
    public var imageName: String
    public var name: String
    @State var textColor: Bool
    
    var body: some View {
        VStack (spacing: 10) {
            Image(imageName)
                .resizable()
                .frame(width: 30, height: 30)
            
            Text(name)
                .font(.system(size: 13))
                .fontWeight(.bold)
                .foregroundColor(textColor ? .blue : .gray)
        }
        .frame(width: 100, height: 75)
    }
}


#Preview {
    EachCategoryView(categories: MockData.sampleCate,
                     Selected: .constant(0))
}
