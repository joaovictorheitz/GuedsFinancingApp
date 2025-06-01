//
//  TransactionRowView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 26/05/25.
//

import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    
    var body: some View {
        HStack {
            Image(systemName: transaction.type == .income ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundColor(transaction.type == .income ? .green : .red)
            VStack(alignment: .leading) {
                Text(transaction.name)
                Text(transaction.paymentMethod == .credit ? "Crédito" : "Débito")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            
            Text("\(transaction.type == .income ? "+" : "-") \(transaction.value.toBrazilianCurrency() ?? "R$ 0,00")")
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .contentShape(Rectangle())
    }
}
