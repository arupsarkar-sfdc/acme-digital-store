//
//  SearchBar.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI
struct SearchBar: View {
    @Binding var text: String
    var viewModel: StoreViewModel
    
    var body: some View {
        HStack {
            TextField("Search products...", text: $text, onEditingChanged: { _ in
                // Trigger search result update
                DispatchQueue.main.async {
                    viewModel.fetchSearchResults()
                }
            })
            .padding(7)
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
        .padding()
    }
}
