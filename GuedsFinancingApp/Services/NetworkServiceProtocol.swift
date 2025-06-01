import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: any NetworkRequest, responseType: T.Type) async throws -> T
} 
