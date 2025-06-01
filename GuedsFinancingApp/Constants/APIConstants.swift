import Foundation

enum APIConstants {
    static let baseURL = "https://financing-app-vapor.e48vwp.easypanel.host"
    static let transactionsEndpoint = "/transactions"
    
    static var transactionsURL: URL? {
        URL(string: baseURL + transactionsEndpoint)
    }
} 
