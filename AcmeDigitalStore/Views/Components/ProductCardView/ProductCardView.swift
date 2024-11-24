//
//  ProductCardView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUICore
import SwiftUI

struct ProductCardView: View {
    let product: Product
    var viewModel: StoreViewModel
    @State private var showProductDetail = false
    private let engagementService = EngagementTrackingService.shared
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(product.imageName)
                .resizable()
                .frame(width: 120, height: 120)
                .cornerRadius(8)
            Text(product.name)
                .font(.subheadline)
            Text("$\(product.price, specifier: "%.2f")")
                .font(.caption)
            Button(action: {
                viewModel.addToCart(product: product)
            }) {
                HStack {
                    Image(systemName: "cart.badge.plus")
                    Text("Add to Cart")
                }
                .padding(5)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .trackScreen("ProductCartView")
        .locationAware()
        .onTapGesture {
            showProductDetail = true
            //capture product browse engagement
            engagementService.trackEvent(
                type: .catalog(.view),
                attributes:
                    [
                        "catalogObjectId": product.id.uuidString,
                        "type": "ProductBrowse",
                        "name": product.name,
                        "price": product.price,
                        "PROMO_CODE": product.promotion,
                        "sizes": ["S", "M", "L"],
                        "skus": ["\(product.id.uuidString)-S", "\(product.id.uuidString)-M", "\(product.id.uuidString)-L"]
                    ]
            )
        }
        .sheet(isPresented: $showProductDetail) {
            ProductDetailView(product: product)
        }
        
    }
}
