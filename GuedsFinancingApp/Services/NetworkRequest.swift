import Foundation

protocol NetworkRequest {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
}

extension NetworkRequest {
    var headers: [String: String]? { return nil }
    var parameters: [String: Any]? { return nil }
    var body: Data? { return nil }
} 