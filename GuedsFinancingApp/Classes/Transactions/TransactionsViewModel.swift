//
//  TransactionsViewModel.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import Foundation
import SwiftUI
import Combine

class TransactionsViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []

    private let transactionsProvider = TransactionsProvider()
        
    func onAppear() {
        fetchTransactions()
    }
    
    func fetchTransactions() {
        _ = Task { [weak self] in guard let self else { return }
                let response = try await transactionsProvider.getTransactions()
            
                await handleGetTransactionsResponse(response)
            
            } catch: { _ in }
    }
    
    @MainActor
    private func handleGetTransactionsResponse(_ response: TransactionsResponse) async {
        transactions = response.items
    }
    
    private func handleResponse(_ response: Subscribers.Completion<NetworkError>) {
        
    }
}

extension Task where Failure == Never, Success == Void {
    init(priority: TaskPriority? = nil, operation: @escaping () async throws -> Void, `catch`: @escaping (Error) -> Void) {
        self.init(priority: priority) {
            do {
                _ = try await operation()
            } catch {
//                `catch`(error)
            }
        }
    }
}
