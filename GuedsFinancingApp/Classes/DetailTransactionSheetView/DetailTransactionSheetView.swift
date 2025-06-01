//
//  DetailTransactionSheetView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import SwiftUI

struct DetailTransactionSheetView: View {
    @State var transaction: Transaction
    
    let saveButtonAction: (Transaction) -> Void
    let cancelButtonAction: (DismissAction) -> Void
    
    var body: some View {
        let builder = DetailTransactionSheetBuilder(saveButtonAction: saveButtonAction, cancelButtonAction: cancelButtonAction)
        
        TransactionDataView(transaction: transaction, builder: builder)
    }
}

#Preview {
    DetailTransactionSheetView(transaction: Transaction(), saveButtonAction: { _ in }, cancelButtonAction: { _ in })
}
