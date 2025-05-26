import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case httpError(Int)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "Nenhum dado recebido"
        case .decodingError:
            return "Erro ao decodificar dados"
        case .httpError(let statusCode):
            return "Erro HTTP: \(statusCode)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
} 