//
//  Product.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import Foundation

struct Product: Identifiable {
    let id: UUID
    let name: String
    let price: Double
    let imageName: String
    let description: String
    let catalog: String
    let promotion: String
    
    
    static func mockTrendingProducts() -> [Product] {
        return [
            Product(
                id: UUID(),
                name: "Mens Casual Dress",
                price: 19.99,
                imageName: "mens_casual",
                description: "A perfect blend of comfort and style, this casual dress is ideal for daily wear or semi-formal outings.",
                catalog: "Lightweight, available in multiple sizes, wrinkle-resistant.",
                promotion: "Discounted 20% for the season, Buy 2 Get 1 Free"
            
            ),
            Product(
                id: UUID(),
                name: "Womens Formal Dress",
                price: 29.99,
                imageName: "womens_formal_dress",
                description: "Elegant and professional, this formal dress suits office wear or special occasions.",
                catalog: "Slim fit, premium fabric, classic black and navy options",
                promotion: "Free shipping on orders over $50, loyalty points available"
            ),
            Product(
                id: UUID(),
                name: "Mens Suit",
                price: 29.99,
                imageName: "mens_suit",
                description: "A tailored suit for men offering a modern fit and sharp style, perfect for any formal event",
                catalog: "Available in 3-piece or 2-piece options, stain-resistant, machine washable",
                promotion: "Bundle with a shirt and get 10% off, limited-time flash sale"
                
            ),
            Product(
                id: UUID(),
                name: "Womens Jeans",
                price: 29.99,
                imageName: "womens_jeans",
                description: "High-quality denim jeans designed for comfort and durability with a trendy fit",
                catalog: "Stretchable, high-rise fit, wide range of sizes",
                promotion: "Weekend sale - 15% off, Spend $100 and Save $20"
            )
        ]
    }
    
    static func mockMostSearchedProducts() -> [Product] {
        return [
            Product(
                id: UUID(),
                name: "Teens Dress",
                price: 15.99,
                imageName: "teens_dress",
                description: "A chic and colorful dress perfect for casual outings or parties for teens",
                catalog: "Lightweight fabric, vibrant patterns, summer collection",
                promotion: "Buy 2 for $25, free gift wrapping"
            ),
            Product(
                id: UUID(),
                name: "Womens Shirt",
                price: 25.99,
                imageName: "womens_shirt",
                description: "A versatile shirt that combines style with comfort, suitable for casual or formal settings",
                catalog: "Breathable cotton, button-up style, pastel color options",
                promotion: "Early bird discount of 10%, extra loyalty points for members"
            )
            
        ]
    }
    
    static func mockAllProducts() -> [Product] {
        return mockTrendingProducts() + mockMostSearchedProducts()
    }
}
