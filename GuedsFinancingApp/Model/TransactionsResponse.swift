//
//  TransactionsResponse.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import Foundation

struct TransactionsResponse: Codable {
    let metadata: Metadata
    let items: [Transaction]
}
