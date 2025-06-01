//
//  TransactionRequest.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 26/05/25.
//

struct TransactionRequest: NetworkRequest {
    typealias Body = Transaction
    
    let type: _Type
    
    var baseURL = APIConstants.baseURL
    var path: String { type.path }
    var method: HTTPMethod { type.method }
    var body: Body? { type.body }
    
    enum _Type {
        case get, create(Body), update(Transaction), delete(Transaction)
        
        var path: String {
            switch self {
            case .update(let transaction), .delete(let transaction):
                APIConstants.transactionsEndpoint + "/\(transaction.id)"
            default:
                APIConstants.transactionsEndpoint
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .get:
                return .GET
            case .create:
                return .POST
            case .update:
                return .PUT
            case .delete:
                return .DELETE
            }
        }
        
        var body: Body? {
            switch self {
            case .get, .delete:
                return nil
            case .create(let body), .update(let body):
                return body
            }
        }
    }
}
