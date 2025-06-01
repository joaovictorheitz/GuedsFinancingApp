//
//  Decimal+Extension.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import Foundation

extension Decimal {
    static let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        return formatter
    }()
    
    func toBrazilianCurrency() -> String? {
        Decimal.currencyFormatter.string(from: self as NSNumber)
    }
}
