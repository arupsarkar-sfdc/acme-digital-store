//
//  ShoppingCartButton.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI

struct ShoppingCartButton: View {
    @ObservedObject var viewModel: StoreViewModel
    
    var body: some View {
        NavigationLink(destination: ShoppingCartView(cart: $viewModel.shoppingCart, viewModel: viewModel)) {
            HStack {
                Image(systemName: "cart.fill")
                Text("Shopping Cart (\(viewModel.shoppingCart.count))")
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

