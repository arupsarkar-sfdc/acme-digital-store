//
//  CheckoutView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//
import SwiftUI

struct CheckoutView: View {
    @ObservedObject var viewModel: StoreViewModel
    @State private var paymentProcessing = false
    @State private var paymentSuccessMessage: String? = nil
    @State private var countdown = 4
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Checkout")
                    .font(.largeTitle)
                    .padding()
                
                Text("Total Items: \(totalItems())")
                Text("Total Price: $\(totalPrice(), specifier: "%.2f")")
                
                Button(action: {
                    simulatePayment()
                }) {
                    HStack{
                        Image(systemName: "creditcard.fill")
                        Text("Complete Payment")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(8)


                }
                .padding()
                .disabled(paymentProcessing)
                
                if let message = paymentSuccessMessage {
                    
                    VStack(spacing: 8) {
                        Text(message)
                            .foregroundColor(.green)

                    }
                    .padding()
                }
            }
            .padding()
            .navigationTitle("Checkout")
            .trackScreen("CheckoutViewScreen")
        }

    }
    
    private func totalItems() -> Int {
        viewModel.shoppingCart.reduce(0) { $0 + $1.quantity }
    }
    
    private func totalPrice() -> Double {
        viewModel.shoppingCart.reduce(0) { $0 + ($1.product.price * Double($1.quantity)) }
    }
    
    private func simulatePayment() {
        paymentProcessing = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            paymentProcessing = false
            paymentSuccessMessage = "Payment processed successfully"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                viewModel.emptyShoppingCart()
            }
        }
    }
    
}
