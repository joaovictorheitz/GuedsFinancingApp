//
//  GetTransactionsRequest.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 26/05/25.
//

struct TransactionRequest: NetworkRequest {
    let type: _Type
    
    var baseURL = APIConstants.baseURL
    var path: String { type.path }
    var method: HTTPMethod { type.method }
    
    enum _Type {
        case get, create
        
        var path: String {
            APIConstants.transactionsEndpoint
        }
        
        var method: HTTPMethod {
            switch self {
            case .get:
                return .GET
            case .create:
                return .POST
            }
        }
    }
}
