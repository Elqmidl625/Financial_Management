//
//  InputView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import SwiftUI

struct InputView: View {
    
    @ObservedObject var vm: EditInOutputViewModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = InOutputViewModel()
    @State public var Selected: Int = 0
    @Binding var isSpentView: Bool
    
    @State private var showAlert = false
    
    
    var body: some View {
        List {
            Section ("Information:") {
                DatePicker("Day spent: ",
                           selection: $vm.information.dateOfInfor,
                           displayedComponents: [.date]) .datePickerStyle(.compact)
                
                TextField("Note: ",
                          text: $vm.information.note,
                          axis: .vertical)
                .keyboardType(.namePhonePad)
                
                TextField("Money Spent: ", text: $vm.information.money) .keyboardType(.numberPad)
            }
            
            Section ("Categories:") {
                    LazyVGrid(columns: viewModel.columns, spacing: 10) {
                        ForEach(MockData.categories){ category in
                            EachCategoryView(categories: category,
                                             Selected: $Selected)
                            .onTapGesture {
                                Selected = category.id.hashValue
                                vm.information.name = category.name
                                vm.information.imageName = category.imageName
                                vm.information.spentOrGained = true
                            }
                        }
                    }
            }
            .padding(.top)
        }
        
        Button(action: {
            do {
                if vm.information.name == "" || vm.information.money == "" {
                    showAlert = true
                }
            
                else {
                    try vm.save()
                    dismiss()
                }
                
            } catch {
                print(error)
            }
        }, label: {
            Text("Add Transaction")
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Lack of information!"),
                  message: Text("Did you drop them or something?"),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    InputView(vm: .init(provider: .shared), isSpentView: .constant(true))
}
