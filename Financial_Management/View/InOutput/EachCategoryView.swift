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
            }
    }
}


struct ButtonCustom: View {
    
    public var imageName: String
    public var name: String
    @State var textColor: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 100,
                       height: 100)
                .foregroundColor(.gray)
                .opacity(0.5)
                .cornerRadius(15)
            
            VStack (spacing: 5) {
                Image(imageName)
                    .resizable()
                    .frame(width: 60,
                           height: 60)
                
                Text(name)
                    .font(.system(size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(textColor ? .blue : .gray)
            }
        }
    }
}


#Preview {
    EachCategoryView(categories: MockData.sampleCate,
                     Selected: .constant(0))
}
