//
//  MainTabView.swift
//  GuedsFinancingApp
//
//  Created by João Victor de Souza Guedes on 31/05/25.
//

import SwiftUI

struct MainTabView: View {
    @State var index = 0
    
    var body: some View {
        TabView {
            Tab("Transações", systemImage: "list.dash") {
                TransactionsView()
            }
            
            Tab("ContentView", systemImage: "globe") {
                ContentView()
            }
        }
    }
}

#Preview {
    MainTabView()
}
