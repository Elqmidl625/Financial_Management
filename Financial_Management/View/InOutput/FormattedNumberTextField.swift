//
//  FormattedNumberTextField.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI

struct FormattedNumberTextField: View {
    @Binding var text: String
    let placeholder: String
    @FocusState private var isFocused: Bool
    @State private var displayText: String = ""
    
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        TextField(placeholder, text: $displayText)
            .keyboardType(.numberPad)
            .focused($isFocused)
            .onChange(of: displayText) { oldValue, newValue in
                // Remove all non-digit characters
                let digits = newValue.filter { $0.isNumber }
                
                if !digits.isEmpty {
                    if let intValue = Int(digits) {
                        // Update the binding with raw number (without formatting)
                        text = "\(intValue)"
                        // Format display text with thousand separators
                        displayText = numberFormatter.string(from: NSNumber(value: intValue)) ?? digits
                    }
                } else {
                    text = ""
                    displayText = ""
                }
            }
            .onAppear {
                // Initialize display text with formatted value
                if let intValue = Int(text) {
                    displayText = numberFormatter.string(from: NSNumber(value: intValue)) ?? text
                } else {
                    displayText = text
                }
            }
            .onChange(of: text) { oldValue, newValue in
                // Update display text when binding changes externally
                if newValue.isEmpty {
                    displayText = ""
                } else if let intValue = Int(newValue) {
                    let formatted = numberFormatter.string(from: NSNumber(value: intValue)) ?? newValue
                    // Only update if different to avoid infinite loops
                    if displayText != formatted {
                        displayText = formatted
                    }
                } else {
                    displayText = newValue
                }
            }
            .onChange(of: isFocused) { oldValue, newValue in
                // When losing focus, sync displayText with text binding
                if !newValue {
                    if text.isEmpty {
                        displayText = ""
                    } else if let intValue = Int(text) {
                        displayText = numberFormatter.string(from: NSNumber(value: intValue)) ?? text
                    }
                }
            }
    }
}

