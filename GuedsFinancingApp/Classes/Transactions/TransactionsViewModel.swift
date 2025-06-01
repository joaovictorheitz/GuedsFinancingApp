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
    @Published var showSheet = false
    @Published var sheet: TransactionsView.Sheets?
    @Published var isLoading = false

    private let transactionsProvider = TransactionsProvider()
        
    func onAppear() {
        fetchTransactions()
    }
    
    func fetchTransactions() {
        _ = Task { [weak self] in guard let self else { return }
                await setIsLoading(true)
            
                let response = try await transactionsProvider.getTransactions()
            
                await handleGetTransactionsResponse(response)
            
            } catch: { _ in }
    }
    
    @MainActor
    private func handleGetTransactionsResponse(_ response: TransactionsResponse) async {
        transactions = response.items
        
        setIsLoading(false)
    }
    
    func plusButtonAction() {
        Task {
            await showSheet(true, sheet: .newTransaction(createTransaction(newTransaction:)))
        }
    }
    
    @MainActor
    private func showSheet(_ value: Bool, sheet: TransactionsView.Sheets? = nil) {
        showSheet = value
        self.sheet = sheet
    }
    
    func newTransactionCallback(newTransaction: Transaction) {
        createTransaction(newTransaction: newTransaction)
    }
    
    private func createTransaction(newTransaction: Transaction) {
        _ = Task { [weak self] in guard let self else { return }
            let _ = try await transactionsProvider.createTransaction(transaction: newTransaction)
            
            await showSheet(false)
            reloadTransactions()
        } catch: { error in
            
        }
    }
    
    @Sendable
    func reloadTransactions() {
        fetchTransactions()
    }
    
    @MainActor
    private func setIsLoading(_ value: Bool) {
        isLoading = value
    }
    
    @MainActor
    func onTapTransactionRow(_ transaction: Transaction) {
        showSheet(true, sheet: .detailTransaction(transaction, editTransaction(_:)))
    }
    
    private func editTransaction(_ transaction: Transaction) {
        _ = Task { [weak self] in guard let self else { return }
            _ = try await transactionsProvider.editTransaction(transaction: transaction)
            
            await showSheet(false)
            reloadTransactions()
        } catch: { _ in }
    }
    
    func deleteTransaction(_ transaction: Transaction) {
        _ = Task { [weak self] in guard let self else { return }
            _ = try await transactionsProvider.deleteTransaction(transaction: transaction)
                
            reloadTransactions()
        } catch: { _ in }
    }
}
