//
//  GetTransactionsRequest.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 26/05/25.
//

struct GetTransactionsRequest: NetworkRequest {
    let baseURL = APIConstants.baseURL
    let path = APIConstants.transactionsEndpoint
    let method: HTTPMethod = .GET
}
