//
//  TrendingProductsView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//
import SwiftUICore
import SwiftUI


struct TrendingProductsView: View {
    let trendingProducts: [Product]
    var viewModel: StoreViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Trending Products")
                .font(.headline)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(trendingProducts) { product in
                        ProductCardView(product: product, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
            }
        }
        .trackScreen("TrendingProductsView")
    }
}
