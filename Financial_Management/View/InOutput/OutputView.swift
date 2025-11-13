//
//  OutputView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 2/8/24.
//

import SwiftUI

struct OutputView: View {
    
    @ObservedObject var vm: EditInOutputViewModel
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = InOutputViewModel()
    @State public var SelectedGained: Int = 0
    @Binding var isSpentView: Bool
    
    @State private var showAlert = false

    
    var body: some View {
        List {
            Section ("Information:") {
                DatePicker("Day Gained: ",
                           selection: $vm.information.dateOfInfor,
                           displayedComponents: [.date]) .datePickerStyle(.compact)
                
                TextField("Note: ",
                          text: $vm.information.note,
                          axis: .vertical)
                .keyboardType(.namePhonePad)
                
                TextField("Money Gained: ", text: $vm.information.money) .keyboardType(.numberPad)
            }
            
            Section ("Categories:") {
                    LazyVGrid(columns: viewModel.columns, spacing: 10) {
                        ForEach(MockData.categoriesGained){ categoryGained in
                            EachCategoryView(categories: categoryGained,
                                             Selected: $SelectedGained)
                            .onTapGesture {
                                SelectedGained = categoryGained.id.hashValue
                                vm.information.name = categoryGained.name
                                vm.information.imageName = categoryGained.imageName
                                vm.information.spentOrGained = false
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
                    vm.startNewInformation(date: vm.information.dateOfInfor, spentOrGained: false)
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
                  message: Text("Did you steal them or something?"),
                  dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    OutputView(vm: .init(provider: .shared), isSpentView: .constant(false))
}
