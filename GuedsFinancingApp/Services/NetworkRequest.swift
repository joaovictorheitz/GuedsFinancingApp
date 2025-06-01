import Foundation

protocol NetworkRequest {
    associatedtype Body: Encodable
    
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Body? { get }
}

extension NetworkRequest {
    var headers: [String: String]? { return nil }
    var parameters: [String: Any]? { return nil }
    var body: Body? { return nil }
}
