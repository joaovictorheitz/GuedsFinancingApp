import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T
} 