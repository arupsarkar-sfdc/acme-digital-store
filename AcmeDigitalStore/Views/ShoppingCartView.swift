//
//  ShoppingCartView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI

struct ShoppingCartView: View {
    @Binding var cart: [CartItem]
    @ObservedObject var viewModel: StoreViewModel
    
    var body: some View {
        List {
            ForEach(cart.indices, id: \.self) { index in
                HStack {
                    Image(cart[index].product.imageName)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                    VStack(alignment: .leading) {
                        Text(cart[index].product.name)
                        Text("$\(cart[index].product.price, specifier: "%.2f")")
                    }
                    Spacer()
                    VStack {
                        HStack {
                            Button(action: {
                                decrementQuantity(index: index)
                            }) {
                                Image(systemName: "minus.circle")
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Text("\(cart[index].quantity)")
                                .frame(width: 30)
                            Button(action: {
                                incrementQuantity(index: index)
                            }) {
                                Image(systemName: "plus.circle")
                            }
                            .buttonStyle(BorderlessButtonStyle()) 
                        }
                        .padding(.vertical, 4)
                        Text("Total: $\(Double(cart[index].quantity) * cart[index].product.price, specifier: "%.2f")")
                            .font(.caption)
                    }
                    .trackScreen("ShoppingCartView")
                    .frame(width: 120)
                    Button(action: {
                        cart.remove(at: index)
                    }) {
                        Image(systemName: "trash.fill")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
            
            NavigationLink(destination: CheckoutView(viewModel: viewModel)) {
                
                HStack {
                    Image(systemName: "cart.fill")
                    Text("Proceed to Checkout")
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.green)
                .cornerRadius(8)

            }
            .padding()
        }
        .navigationTitle("Shopping Cart")
    }
    
    private func decrementQuantity(index: Int) {
        print("Before decrement cart count", cart[index].quantity)
        if cart[index].quantity > 1 {
            cart[index].quantity -= 1
        }
        print("After decrement cart count", cart[index].quantity)
    }
    
    private func incrementQuantity(index: Int) {
        print("Before increment cart count", cart[index].quantity)
        cart[index].quantity += 1
        print("After increment cart count", cart[index].quantity)
    }
    
    private func removeItem(at index: Int) {
        cart.remove(at: index)
    }
}
