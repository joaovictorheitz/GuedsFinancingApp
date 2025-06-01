//
//  Transaction.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import Foundation

public class Transaction: Codable, Identifiable, Hashable, ObservableObject {
    var date: Date
    var type: _Type
    var name: String
    var value: Decimal
    var paymentMethod: PaymentMethod
    public let id: String
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return formatter
    }()
        
    enum CodingKeys: CodingKey {
        case date
        case type
        case name
        case value
        case paymentMethod
        case id
    }
    
    enum _Type: Int, Codable {
        case expense = 0, income = 1
    }
    
    enum PaymentMethod: Int8, Codable {
        case credit = 0, debit = 1
    }
    
    init() {
        self.id = UUID().uuidString
        self.date = Date()
        self.type = .expense
        self.name = ""
        self.value = 0
        self.paymentMethod = .credit
    }
    
    required public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        
        let date = try container.decodeIfPresent(String.self, forKey: .date)
        self.date = Transaction.dateFormatter.date(from: date ?? "") ?? Date()
        
        let type = try container.decode(Int.self, forKey: .type)
        self.type = .init(rawValue: type)!
        
        self.name = try container.decode(String.self, forKey: .name)
        self.value = try container.decode(Decimal.self, forKey: .value)
        self.paymentMethod = try container.decode(Transaction.PaymentMethod.self, forKey: .paymentMethod)
    }
    
    public static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dateString = Transaction.dateFormatter.string(from: date)
        try container.encode(dateString, forKey: .date)
        
        try container.encode(self.type, forKey: .type)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.value, forKey: .value)
        try container.encode(self.paymentMethod, forKey: .paymentMethod)
        try container.encode(self.id, forKey: .id)
    }
}
