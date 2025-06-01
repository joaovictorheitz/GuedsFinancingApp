//
//  TransactionDataViewBuilder.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 01/06/25.
//

import SwiftUI

public protocol TransactionDataViewBuilder {
    associatedtype Toolbar: ToolbarContent
    
    var navigationTitle: String { get }
    func makeToolbar(dismissAction: DismissAction, transaction: Transaction) -> Toolbar
}
