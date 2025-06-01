//
//  TransactionDataView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 31/05/25.
//

import SwiftUI

struct TransactionDataView<Builder: TransactionDataViewBuilder>: View {
    @Environment(\.dismiss) public var dismiss
    @StateObject var transaction: Transaction
    
    var builder: Builder
    
    public var body: some View {
        Form {
            nameField
            
            datePickerField
            
            valueField
            
            paymentMethodOption
            
            typeField
        }
        .toolbar { builder.makeToolbar(dismissAction: dismiss, transaction: transaction) }
        .navigationTitle(builder.navigationTitle)
    }
    
    private var datePickerField: some View {
        DatePicker("Data", selection: $transaction.date, displayedComponents: .date)
    }
    
    private var nameField: some View {
        TextField("Nome", text: $transaction.name)
    }
    
    private var typeField: some View {
        Picker("Tipo", selection: $transaction.type) {
            Text("Receita").tag(Transaction._Type.income)
            Text("Gasto").tag(Transaction._Type.expense)
        }
        .pickerStyle(.segmented)
    }
    
    private var paymentMethodOption: some View {
        Picker("Método de pagamento", selection: $transaction.paymentMethod) {
            Text("Crédito").tag(Transaction.PaymentMethod.credit)
            Text("Débito").tag(Transaction.PaymentMethod.debit)
        }
    }
    
    private var valueField: some View {
        return TextField("Preço", value: $transaction.value, format: .currency(code: "BRL"))
                    .keyboardType(.decimalPad)
    }
}
