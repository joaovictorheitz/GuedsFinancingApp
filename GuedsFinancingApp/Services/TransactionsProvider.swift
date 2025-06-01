import Foundation

class TransactionsProvider {
    let networkService = NetworkService()
    
    func getTransactions() async throws -> TransactionsResponse {
        let request = TransactionRequest(type: .get)
        return try await networkService.request(request, responseType: TransactionsResponse.self)
    }
    
    func createTransaction(transaction: Transaction) async throws -> Transaction {
        let request = TransactionRequest(type: .create(transaction))
        return try await networkService.request(request, responseType: Transaction.self)
    }
    
    func editTransaction(transaction: Transaction) async throws -> Transaction {
        let request = TransactionRequest(type: .update(transaction))
        return try await networkService.request(request, responseType: Transaction.self)
    }
    
    func deleteTransaction(transaction: Transaction) async throws -> Transaction {
        let request = TransactionRequest(type: .delete(transaction))
        return try await networkService.request(request, responseType: Transaction.self)
    }
}
