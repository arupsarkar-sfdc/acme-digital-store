//
//  MostSearchedView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUICore
import SwiftUI

struct MostSearchedView: View {
    let mostSearchedProducts: [Product]
    var viewModel: StoreViewModel
    var einsteinPersonalizationViewModel: EinsteinPersonalizationViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Most Searched Products")
                    .font(.title2.bold())
                Spacer()
                Button(action: { /* Show all trending products */ }) {
                    Text("See All")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemGray6))
                    .shadow(color: .gray.opacity(0.1), radius: 2, x: 0, y: 1)
            )
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(mostSearchedProducts) { product in
                        ProductCardView(product: product, viewModel: viewModel, einsteinPersonalizationViewModel: einsteinPersonalizationViewModel)
                    }
                }
                .padding(.horizontal)
            }
        }
        .trackScreen("MostSearchedView")
    }
}
