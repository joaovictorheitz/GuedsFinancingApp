//
//  Transaction.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import Foundation

struct Transaction: Codable {
    let date: Date
    let type: Int
    let name: String
    let value: Double
    let paymentMethod: Int
    let id: String
}
