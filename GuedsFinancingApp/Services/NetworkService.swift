import Foundation
import Combine

// MARK: - Network Service Implementation
class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(_ request: NetworkRequest, responseType: T.Type) async throws -> T {
        let urlRequest = try await createURLRequest(from: request)
        
        // Log da request
        logRequest(urlRequest)
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            // Log da response
            logResponse(data: data, response: response, for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(NSError(domain: "InvalidResponse", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resposta inválida do servidor"]))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("🔴 [NetworkService] HTTP Error: Status Code \(httpResponse.statusCode)")
                throw NetworkError.httpError(httpResponse.statusCode)
            }
            
            // Decodificar JSON
            do {
                let decoder = JSONDecoder()
                let decodedObject = try decoder.decode(T.self, from: data)
                print("✅ [NetworkService] Successfully decoded response")
                return decodedObject
            } catch {
                print("🔴 [NetworkService] Decoding Error: \(error)")
                if let decodingError = error as? DecodingError {
                    print("🔴 [NetworkService] Decoding Error Details: \(decodingError)")
                }
                throw NetworkError.decodingError
            }
            
        } catch {
            print("🔴 [NetworkService] Network Error: \(error)")
            if error is NetworkError {
                throw error
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
    
    // MARK: - Private Methods
    private func createURLRequest(from request: NetworkRequest) async throws -> URLRequest {
        var urlComponents = URLComponents(string: request.baseURL + request.path)
        
        // Adicionar query parameters para GET requests
        if request.method == .GET, let parameters = request.parameters {
            urlComponents?.queryItems = parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        
        guard let url = urlComponents?.url else {
            print("🔴 [NetworkService] Invalid URL: \(request.baseURL + request.path)")
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.timeoutInterval = 30 // Timeout de 30 segundos
        
        // Adicionar headers personalizados (sobrescreverão a authorization se fornecida)
        request.headers?.forEach { key, value in
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        
        urlRequest.setApiKeyAuthorization()
        
        // Configurar body para métodos que não sejam GET
        if request.method != .GET {
            if let body = request.body {
                urlRequest.httpBody = body
            } else if let parameters = request.parameters {
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters)
                    urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                } catch {
                    print("🔴 [NetworkService] Failed to serialize parameters: \(error)")
                    throw NetworkError.networkError(error)
                }
            }
        }
        
        return urlRequest
    }
    
    // MARK: - Logging Methods
    private func logRequest(_ urlRequest: URLRequest) {
        print("\n🚀 [NetworkService] REQUEST")
        print("📍 URL: \(urlRequest.url?.absoluteString ?? "Unknown")")
        print("🔧 Method: \(urlRequest.httpMethod ?? "Unknown")")
        
        // Log headers
        if let headers = urlRequest.allHTTPHeaderFields, !headers.isEmpty {
            print("📋 Headers:")
            headers.forEach { key, value in
                // Mascarar a Authorization para segurança
                if key.lowercased() == "authorization" {
                    print("   \(key): Bearer ***MASKED***")
                } else {
                    print("   \(key): \(value)")
                }
            }
        }
        
        // Log body
        if let body = urlRequest.httpBody {
            if let bodyString = String(data: body, encoding: .utf8) {
                print("📦 Body: \(bodyString)")
            } else {
                print("📦 Body: \(body.count) bytes")
            }
        }
        
        // Log cURL equivalent
        print("🔗 cURL equivalent:")
        print(generateCurlCommand(from: urlRequest))
        print("─────────────────────────────────────")
    }
    
    private func logResponse(data: Data, response: URLResponse, for request: URLRequest) {
        print("\n📥 [NetworkService] RESPONSE")
        print("📍 URL: \(request.url?.absoluteString ?? "Unknown")")
        
        if let httpResponse = response as? HTTPURLResponse {
            print("📊 Status Code: \(httpResponse.statusCode)")
            
            // Log response headers
            if !httpResponse.allHeaderFields.isEmpty {
                print("📋 Response Headers:")
                httpResponse.allHeaderFields.forEach { key, value in
                    print("   \(key): \(value)")
                }
            }
        }
        
        // Log response data
        if let responseString = String(data: data, encoding: .utf8) {
            print("📄 Response Data:")
            // Limitar o tamanho do log para responses muito grandes
            if responseString.count > 1000 {
                let truncated = String(responseString.prefix(1000))
                print("\(truncated)... [TRUNCATED - Total: \(responseString.count) characters]")
            } else {
                print(responseString)
            }
        } else {
            print("📄 Response Data: \(data.count) bytes (non-UTF8)")
        }
        print("─────────────────────────────────────")
    }
    
    private func generateCurlCommand(from urlRequest: URLRequest) -> String {
        guard let url = urlRequest.url else { return "Invalid URL" }
        
        var curl = "curl -X \(urlRequest.httpMethod ?? "GET")"
        
        // Add headers
        if let headers = urlRequest.allHTTPHeaderFields {
            for (key, value) in headers {
                if key.lowercased() == "authorization" {
                    curl += " \\\n  -H '\(key): Bearer ***MASKED***'"
                } else {
                    curl += " \\\n  -H '\(key): \(value)'"
                }
            }
        }
        
        // Add body
        if let body = urlRequest.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            curl += " \\\n  -d '\(bodyString)'"
        }
        
        curl += " \\\n  '\(url.absoluteString)'"
        
        return curl
    }
}
