//
//  NewTransactionPageBuilder.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import SwiftUI

struct NewTransactionSheetBuilder: TransactionDataViewBuilder {
    let navigationTitle: String = "Nova Transação"
    
    var createButtonAction: (Transaction) -> Void
    var cancelButtonAction: (DismissAction) -> Void
        
    @ToolbarContentBuilder
    func makeToolbar(dismissAction: DismissAction, transaction: Transaction) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { cancelButtonAction(dismissAction) }, label: { Text("Cancelar") })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { createButtonAction(transaction) }, label: { Text("Salvar") })
        }
    }
}
