//
//  DetailTransactionSheetBuilder.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import SwiftUI

struct DetailTransactionSheetBuilder: TransactionDataViewBuilder {
    let navigationTitle: String = "Detalhe da Transação"
    
    var saveButtonAction: (Transaction) -> Void
    var cancelButtonAction: (DismissAction) -> Void
        
    @ToolbarContentBuilder
    func makeToolbar(dismissAction: DismissAction, transaction: Transaction) -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: { cancelButtonAction(dismissAction) }, label: { Text("Voltar") })
        }
        
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: { saveButtonAction(transaction) }, label: { Text("Salvar") })
        }
    }
}
