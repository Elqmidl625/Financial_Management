//
//  Currency.swift
//  Financial_Management
//
//  Created by AI on 12/11/25.
//

import Foundation
import SwiftUI

// Supported currencies
enum Currency: String, CaseIterable, Codable {
    case usd = "USD"
    case vnd = "VND"
    case eur = "EUR"
    case gbp = "GBP"
    case jpy = "JPY"
    case cny = "CNY"
    case krw = "KRW"
    case thb = "THB"
    case sgd = "SGD"
    case aud = "AUD"
    case cad = "CAD"
    
    var symbol: String {
        switch self {
        case .usd: return "$"
        case .vnd: return "₫"
        case .eur: return "€"
        case .gbp: return "£"
        case .jpy: return "¥"
        case .cny: return "¥"
        case .krw: return "₩"
        case .thb: return "฿"
        case .sgd: return "S$"
        case .aud: return "A$"
        case .cad: return "C$"
        }
    }
    
    var name: String {
        switch self {
        case .usd: return "US Dollar"
        case .vnd: return "Vietnamese Dong"
        case .eur: return "Euro"
        case .gbp: return "British Pound"
        case .jpy: return "Japanese Yen"
        case .cny: return "Chinese Yuan"
        case .krw: return "South Korean Won"
        case .thb: return "Thai Baht"
        case .sgd: return "Singapore Dollar"
        case .aud: return "Australian Dollar"
        case .cad: return "Canadian Dollar"
        }
    }
    
    var displayName: String {
        "\(name) (\(symbol))"
    }
}

// Manager for selected currency
class CurrencyManager: ObservableObject {
    static let shared = CurrencyManager()
    
    @Published var selectedCurrency: Currency {
        didSet {
            UserDefaults.standard.set(selectedCurrency.rawValue, forKey: currencyKey)
        }
    }
    
    private let currencyKey = "selectedCurrency"
    
    private init() {
        if let savedCurrency = UserDefaults.standard.string(forKey: currencyKey),
           let currency = Currency(rawValue: savedCurrency) {
            selectedCurrency = currency
        } else {
            selectedCurrency = .usd  // Default to USD
        }
    }
    
    var currencySymbol: String {
        selectedCurrency.symbol
    }
    
    // Number formatter for displaying amounts with thousand separators
    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = "."
        formatter.usesGroupingSeparator = true
        return formatter
    }()
    
    func formatAmount(_ amount: Int) -> String {
        let formattedNumber = numberFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(formattedNumber)\(selectedCurrency.symbol)"
    }
    
    func formatAmount(_ amount: String) -> String {
        // Remove existing formatting for parsing
        let cleanedAmount = amount.replacingOccurrences(of: ".", with: "")
        if let intAmount = Int(cleanedAmount) {
            return formatAmount(intAmount)
        }
        return "\(amount)\(selectedCurrency.symbol)"
    }
    
    // Format number only (without currency symbol) - for TextField input
    func formatNumber(_ amount: Int) -> String {
        numberFormatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    // Parse formatted string to Int - for TextField input
    func parseAmount(_ formattedAmount: String) -> Int {
        let cleaned = formattedAmount.replacingOccurrences(of: ".", with: "")
        return Int(cleaned) ?? 0
    }
}

