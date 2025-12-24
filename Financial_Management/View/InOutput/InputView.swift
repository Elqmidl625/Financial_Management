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
        VStack {
            ZStack {
                Picker("", selection: $isSpentView) {
                    Text("Spent").tag(true)
                    Text("Gained").tag(false)
                }
                .pickerStyle(.segmented)
                .controlSize(.large)
                .font(.headline)
                .padding(.horizontal, 12)
            }
            .frame(width: 375)
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

#Preview {
    InputView()
}
