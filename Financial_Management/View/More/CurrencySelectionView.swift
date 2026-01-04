//
//  CurrencySelectionView.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import SwiftUI

struct CurrencySelectionView: View {
    @StateObject private var currencyManager = CurrencyManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            Section {
                ForEach(Currency.allCases, id: \.self) { currency in
                    HStack {
                        Text(currency.displayName)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        if currencyManager.selectedCurrency == currency {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        currencyManager.selectedCurrency = currency
                    }
                }
            } header: {
                Text("Select Currency")
            } footer: {
                Text("The currency symbol will be used throughout the app to display amounts.")
            }
        }
        .navigationTitle("Currency")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CurrencySelectionView()
    }
}

