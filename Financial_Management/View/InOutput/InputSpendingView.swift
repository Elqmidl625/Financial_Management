//
//  InputView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import SwiftUI

struct InputSpendingView: View {
    
    @ObservedObject var vm: EditInputViewModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = InputViewModel()
    @State public var Selected: Int = 0
    @Binding var isSpentView: Bool
    @ObservedObject private var categoryManager = CustomCategoryManager.shared
    
    @State private var showAlert = false
    
    
    var body: some View {
        List {
            Section ("Information:") {
                DatePicker("Date: ",
                           selection: $vm.information.dateOfInfor,
                           displayedComponents: [.date]) .datePickerStyle(.compact)
                
                TextField("Note: ",
                          text: $vm.information.note,
                          axis: .vertical)
                .keyboardType(.namePhonePad)
                
                FormattedNumberTextField(text: $vm.information.money, placeholder: "Amount: ")
                    .id(vm.information.objectID)
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
                    // Prepare a fresh draft so subsequent adds create new rows
                    vm.startNewInformation(date: vm.information.dateOfInfor, spentOrGained: true)
                    // Reset selection highlight
                    Selected = 0
                    dismiss()
                }
                
            } catch {
                print(error)
            }
        }, label: {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                Text("Add Transaction")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(12)
        })
        .padding(.horizontal)
        .padding(.bottom, 8)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Lack of information!"),
                  message: Text("Did you drop them or something?"),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    InputSpendingView(vm: .init(provider: .shared), isSpentView: .constant(true))
}


