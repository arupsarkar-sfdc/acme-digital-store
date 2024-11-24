//
//  ProductDetailView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/22/24.
//
import SwiftUI

struct ProductDetailView: View {
    let product: Product
    @Environment(\.dismiss) private var dismiss
    @State private var isPromotionSelected = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Product Image
                    Image(product.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                        .shadow(radius: 5)
                    
                    // Product Details
                    VStack(alignment: .leading, spacing: 16) {
                        Text(product.name)
                            .font(.title2)
                            .bold()
                        
                        Text(String(format: "$%.2f", product.price))
                            .font(.title3)
                            .foregroundColor(.blue)
                        
                        Text(product.description)
                            .font(.body)
                            .foregroundColor(.secondary)
                        
                        // Catalog Information
                        Text("Product Details")
                            .font(.headline)
                            .padding(.top, 8)
                        
                        Text(product.catalog)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Promotion Box
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Toggle("", isOn: $isPromotionSelected)
                                    .labelsHidden()
                                
                                Text(product.promotion)
                                    .font(.subheadline)
                                    .foregroundColor(.red)
                                    .multilineTextAlignment(.leading)
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                    }
                    .padding()
                }
            }
            .navigationTitle("Product Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
