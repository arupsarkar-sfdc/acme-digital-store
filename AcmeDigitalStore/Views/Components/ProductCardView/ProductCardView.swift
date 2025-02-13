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
    var einsteinPersonalizationViewModel: EinsteinPersonalizationViewModel
    @State private var showProductDetail = false
    private let engagementService = EngagementTrackingService.shared
    //declare the logger service
    private let logger = DataCloudLoggingService.shared
    @State private var isFavorite = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(product.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 120)
                .clipped(antialiased: true)
                .cornerRadius(8)
                .overlay(
                    Button(action: {
                        isFavorite.toggle()
                        trackFavorite(product: product)
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(isFavorite ? .red : .gray)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(8),
                    alignment: .topTrailing
                )
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
            
            // capture the clicks and call trackProductClick
            logger.debug("Product clicked - \(product.id)")
            einsteinPersonalizationViewModel.trackProductClick(productName: product.id)
            
            //capture product browse engagement
            engagementService.trackEvent(
                type: .catalog(.view),
                attributes:
                    [
                        "catalogObjectId": product.id,
                        "type": "ProductBrowse",
                        "name": product.name,
                        "price": product.price,
                        "PROMO_CODE": product.promotion,
                        "sizes": ["S", "M", "L"],
                        "skus": ["\(product.id)-S", "\(product.id)-M", "\(product.id)-L"]
                    ]
            )
        }
        .sheet(isPresented: $showProductDetail) {
            ProductDetailView(product: product)
        }
        
    }
    
    private func trackFavorite(product: Product) {
        logger.debug("Favorite clicked")
        // create a product based on the product model and call viewModel.addToFavorite func with product as func parameter
        //let product = Product(id: "1234", name: "Product", price: 100, promotion: "PROMO")
        viewModel.addToFavorite(product: product)
        
    }
}
