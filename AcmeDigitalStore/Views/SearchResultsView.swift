//
//  SearchResultsView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI

struct SearchResultsView: View {
    let results: [Product]
    var viewModel: StoreViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Search Results")
                .font(.headline)
                .padding(.leading)
            ScrollView(.vertical, showsIndicators: true) {
                VStack(spacing: 15) {
                    ForEach(results) { product in
                        ProductCardView(product: product, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

