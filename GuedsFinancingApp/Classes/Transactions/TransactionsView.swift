//
//  TransactionsView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 24/05/25.
//

import SwiftUI

struct TransactionsView: View {
    @StateObject var viewModel = TransactionsViewModel()
    
    enum Sheets: View {
        case newTransaction((Transaction) -> Void)
        case detailTransaction(Transaction, (Transaction) -> Void)
        
        var cancelAction: (DismissAction) -> Void {
            return { dismiss in dismiss() }
        }
        
        var body: some View {
            switch self {
            case .newTransaction(let createTransaction):
                NewTransactionSheetView(transaction: Transaction(),
                                        cancelButtonAction: cancelAction,
                                        createButtonAction: createTransaction)
            case .detailTransaction(let transaction, let saveTransactionAction):
                DetailTransactionSheetView(transaction: transaction,
                                           saveButtonAction: saveTransactionAction,
                                           cancelButtonAction: cancelAction)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            mainList
                .navigationTitle(Text("Transações"))
                .toolbar { toolbar }
                .redacted(reason: viewModel.isLoading ? .placeholder : [])
        }
        .sheet(isPresented: $viewModel.showSheet, content: {
            NavigationStack {
                switch viewModel.sheet {
                case .newTransaction(let createTransaction):
                    Sheets.newTransaction(createTransaction)
                case .detailTransaction(let transaction, let saveTransaction):
                    Sheets.detailTransaction(transaction, saveTransaction)
                case .none:
                    EmptyView()
                }
            }
        })
        .onAppear(perform: viewModel.onAppear)
    }
    
    private var mainList: some View {
        List {
            ForEach(Array(viewModel.transactions.enumerated()), id: \.offset) { index, transaction in
                if shouldShowSection(for: index) {
                    Section {
                        TransactionRowView(transaction: transaction)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    viewModel.deleteTransaction(transaction)
                                } label: {
                                    Label("Excluir", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                            .onTapGesture { viewModel.onTapTransactionRow(transaction) }
                    } header: {
                        Text(transaction.date.formatted(date: .numeric, time: .omitted))
                    }
                } else {
                    TransactionRowView(transaction: transaction)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                viewModel.deleteTransaction(transaction)    
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                        .onTapGesture { viewModel.onTapTransactionRow(transaction) }
                        
                }
            }
        }
        .refreshable(action: viewModel.reloadTransactions)
    }
    
    @ToolbarContentBuilder
    private var toolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Button(action: viewModel.plusButtonAction) {
                Image(systemName: "plus")
            }
        }
        
        ToolbarItem(placement: .navigationBarLeading) {
            Button(action: {
                
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
            }
        }
    }
    
    private func shouldShowSection(for index: Int) -> Bool {
        if index == 0 {
            return true
        }
        
        let currentTransactionDate = viewModel.transactions[index].date
        let previousTransactionDate = viewModel.transactions[index - 1].date
        
        return !Calendar.current.isDate(currentTransactionDate, inSameDayAs: previousTransactionDate)
    }
}

#Preview {
    NavigationStack {
        TransactionsView()
    }
}
