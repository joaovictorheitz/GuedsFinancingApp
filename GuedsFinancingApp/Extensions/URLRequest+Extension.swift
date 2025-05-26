//
//  URLRequest+Extension.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import Foundation

extension URLRequest {
    mutating func setApiKeyAuthorization() {
        setValue("Bearer \(Secrets.apiKey)", forHTTPHeaderField: "Authorization")
    }
}
