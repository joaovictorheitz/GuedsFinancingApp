//
//  NewTransactionSheetView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import SwiftUI

struct NewTransactionSheetView: View {
    @State var transaction: Transaction
    
    let cancelButtonAction: (DismissAction) -> Void
    let createButtonAction: (Transaction) -> Void
    
    var body: some View {
        let builder = NewTransactionSheetBuilder(createButtonAction: createButtonAction, cancelButtonAction: cancelButtonAction)
        
        TransactionDataView(transaction: transaction, builder: builder)
    }
}

#Preview {
    NewTransactionSheetView(transaction: Transaction(), cancelButtonAction: { _ in }, createButtonAction: { _ in })
}
