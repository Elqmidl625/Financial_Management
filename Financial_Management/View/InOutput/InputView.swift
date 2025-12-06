//
//  InOutputView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 1/8/24.
//

import SwiftUI

struct InputView: View {
    
    @State var isSpentView = true
    var initialDate: Date? = nil
    var provider = InformationProvider.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack (spacing: 15) {
                    Button (action: {
                        isSpentView = true
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(8)
                                .overlay(
                                    isSpentView ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2) : RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0)
                                )
                            Text("Money spent")
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 30)
                    })
                    
                    Button (action: {
                        isSpentView = false
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.gray)
                                .opacity(0.5)
                                .cornerRadius(8)
                                .overlay(
                                    isSpentView ? RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.black, lineWidth: 0) : RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                            Text("Money gained")
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 30)
                    })
                }
                .frame(width: geometry.size.width,
                       height: 35)
                .padding(.vertical)
                
                if isSpentView {
                    InputSpendingView(vm: {
                        let vm = EditInputViewModel(provider: provider)
                        if let date = initialDate {
                            vm.information.dateOfInfor = date
                        }
                        return vm
                    }(),
                              isSpentView: $isSpentView)
                    
                } else {
                    InputIncomeView(vm: {
                        let vm = EditInputViewModel(provider: provider)
                        if let date = initialDate {
                            vm.information.dateOfInfor = date
                        }
                        return vm
                    }(),
                               isSpentView: $isSpentView)
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    InputView()
}
