//
//  MoreView.swift
//  Financial_Management
//
//  Created by Lã Quốc Trung on 29/8/24.
//

import SwiftUI

struct MoreView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text("More")
                    .font(.title)
                    .fontWeight(.bold)
                
                List {
                    Section("Settings") {
                        NavigationLink {
                            CustomCategoryManagerView()
                        } label: {
                            HStack {
                                Image(systemName: "square.grid.2x2")
                                Text("Custom Categories")
                            }
                        }

                        NavigationLink {
                            CurrencySelectionView()
                        } label: {
                            HStack {
                                Image(systemName: "dollarsign.circle")
                                Text("Currency")
                                Spacer()
                                Text(CurrencyManager.shared.currencySymbol)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    MoreView()
}
