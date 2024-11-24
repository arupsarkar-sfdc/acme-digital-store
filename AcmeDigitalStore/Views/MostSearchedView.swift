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
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Most Searched Products")
                .font(.headline)
                .padding(.leading)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(mostSearchedProducts) { product in
                        ProductCardView(product: product, viewModel: viewModel)
                    }
                }
                .padding(.horizontal)
            }
        }
        .trackScreen("MostSearchedView")
    }
}
