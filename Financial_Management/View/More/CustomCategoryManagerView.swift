//
//  CustomCategoryManagerView.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI

struct CustomCategoryManagerView: View {
    @StateObject private var manager = CustomCategoryManager.shared
    @StateObject private var userSession = UserSession.shared
    @State private var showAddSheet = false
    @State private var selectedCategory: CustomCategory?
    @State private var selectedType: Bool = false  // false = expense, true = income
    
    var body: some View {
        List {
            Section {
                Picker("Category Type", selection: $selectedType) {
                    Text("Expense").tag(false)
                    Text("Income").tag(true)
                }
                .pickerStyle(.segmented)
                .controlSize(.large)
                .listRowInsets(EdgeInsets())
                .listRowBackground(Color.clear)
            }
            
            Section {
                ForEach(filteredCategories) { category in
                    CustomCategoryRow(category: category) {
                        selectedCategory = category
                    }
                }
                .onDelete(perform: deleteCategories)
            } header: {
                Text(selectedType ? "Income Categories" : "Expense Categories")
            }
        }
        .navigationTitle("Custom Categories")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    selectedCategory = nil
                    showAddSheet = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddSheet) {
            CustomCategoryEditView(
                category: selectedCategory,
                isIncome: selectedType,
                onSave: { category in
                    if let existing = selectedCategory {
                        manager.updateCustomCategory(category)
                    } else {
                        manager.addCustomCategory(category)
                    }
                    selectedCategory = nil
                    showAddSheet = false
                },
                onCancel: {
                    selectedCategory = nil
                    showAddSheet = false
                }
            )
        }
        .onChange(of: selectedType) {
            selectedCategory = nil
            showAddSheet = false
        }
        .onChange(of: userSession.currentUserId) {
            // Reload categories when user changes
            manager.loadCustomCategories()
        }
    }
    
    private var filteredCategories: [CustomCategory] {
        manager.customCategoriesForType(isIncome: selectedType)
    }
    
    private func deleteCategories(at offsets: IndexSet) {
        let categories = filteredCategories
        for index in offsets {
            do {
                try manager.deleteCustomCategory(categories[index])
            } catch {
                print("Error deleting category: \(error)")
            }
        }
    }
}

struct CustomCategoryRow: View {
    let category: CustomCategory
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 15) {
                Image(systemName: category.systemSymbolName)
                    .font(.system(size: 24))
                    .foregroundColor(category.color)
                    .frame(width: 30)
                
                Text(category.name)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct CustomCategoryEditView: View {
    let category: CustomCategory?
    let isIncome: Bool
    let onSave: (CustomCategory) -> Void
    let onCancel: () -> Void
    
    @State private var name: String = ""
    @State private var selectedSymbol: String = "circle"
    @State private var selectedColor: Color = .blue
    @Environment(\.dismiss) private var dismiss
    
    // Popular SF Symbols - simplified list
    private let symbols = [
        "circle", "star", "heart", "diamond", "square", "triangle",
        "bolt", "flame", "leaf", "drop", "sparkles", "sun.max",
        "moon", "cloud", "snowflake", "star.circle", "heart.circle",
        "cart", "creditcard", "gift", "tag", "ticket", "crown",
        "bell", "flag", "bookmark", "pin", "location", "map",
        "figure.walk", "car", "bicycle", "bus", "airplane",
        "house", "building", "storefront", "globe",
        "wifi", "music.note", "tv", "camera", "photo",
        "film", "video", "mic", "speaker.wave.2", "headphones",
        "pencil", "paintbrush", "wrench", "hammer",
        "briefcase", "laptopcomputer", "iphone", "printer",
        "sportscourt", "figure.run", "figure.swim",
        "basketball", "soccerball", "tennisball",
        "fork.knife", "cup.and.saucer", "wineglass",
        "tshirt", "bag", "backpack",
        "pills", "stethoscope",
        "book", "graduationcap", "paintpalette",
        "doc.text", "folder", "paperclip",
        "plus.circle", "checkmark.circle", "questionmark.circle",
        "dollarsign.circle", "banknote", "chart.line.uptrend.xyaxis",
        "clock", "calendar", "timer"
    ]
    
    private let colors: [Color] = [
        .red, .orange, .yellow, .green, .mint, .teal, .cyan, .blue,
        .indigo, .purple, .pink, .brown, .gray
    ]
    
    init(category: CustomCategory?, isIncome: Bool, onSave: @escaping (CustomCategory) -> Void, onCancel: @escaping () -> Void) {
        self.category = category
        self.isIncome = isIncome
        self.onSave = onSave
        self.onCancel = onCancel
        
        if let category = category {
            _name = State(initialValue: category.name)
            _selectedSymbol = State(initialValue: category.systemSymbolName)
            _selectedColor = State(initialValue: category.color)
        } else {
            _selectedColor = State(initialValue: isIncome ? .blue : .red)
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Category Name", text: $name)
                } header: {
                    Text("Name")
                }
                
                Section {
                    Picker("Symbol", selection: $selectedSymbol) {
                        ForEach(symbols, id: \.self) { symbol in
                            HStack {
                                Image(systemName: symbol)
                                Text(symbol)
                            }
                            .tag(symbol)
                        }
                    }
                } header: {
                    Text("Symbol")
                } footer: {
                    HStack {
                        Image(systemName: selectedSymbol)
                            .font(.system(size: 40))
                            .foregroundColor(selectedColor)
                        Text("Preview")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
                
                Section {
                    ColorPicker("Color", selection: $selectedColor)
                } header: {
                    Text("Color")
                } footer: {
                    HStack {
                        Circle()
                            .fill(selectedColor)
                            .frame(width: 40, height: 40)
                        Text("Preview")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle(category == nil ? "New Category" : "Edit Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: onCancel)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveCategory() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let newCategory = CustomCategory(
            id: category?.id ?? UUID(),
            name: trimmedName,
            systemSymbolName: selectedSymbol,
            color: selectedColor,
            isIncome: isIncome
        )
        
        onSave(newCategory)
    }
}

#Preview {
    NavigationStack {
        CustomCategoryManagerView()
    }
}

