//
//  Product.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import Foundation

struct Product: Identifiable {
    let id: String
    let name: String
    let price: Double
    let imageName: String
    let description: String
    let catalog: String
    let promotion: String
    
    
    static func mockTrendingProducts() -> [Product] {
        return [
            Product(
                id: "female-casual-dress-001",
                name: "Casual Denim Outfit",
                price: 29.99,
                imageName: "womens_casual_denim_outfit",
                description: "Comfortable and trendy denim outfit featuring a sleeveless top and high-waisted jeans, ideal for casual outings.",
                catalog: "Lightweight fabric, available in various sizes, machine washable.",
                promotion: "Buy 1 Get 1 30% Off!"
            ),
            Product(
                // how to make the UUID remain the same
                id: "mens-casual-dress-001",
                name: "Mens Casual Dress",
                price: 19.99,
                imageName: "mens_casual",
                description: "A perfect blend of comfort and style, this casual dress is ideal for daily wear or semi-formal outings.",
                catalog: "Lightweight, available in multiple sizes, wrinkle-resistant.",
                promotion: "Discounted 20% for the season, Buy 2 Get 1 Free"
            
            ),
            Product(
                id: "female-formal-dress-001",
                name: "Womens Formal Dress",
                price: 29.99,
                imageName: "womens_formal_dress",
                description: "Elegant and professional, this formal dress suits office wear or special occasions.",
                catalog: "Slim fit, premium fabric, classic black and navy options",
                promotion: "Free shipping on orders over $50, loyalty points available"
            ),
            Product(
                id: "mens-suit-001",
                name: "Mens Suit",
                price: 29.99,
                imageName: "mens_suit",
                description: "A tailored suit for men offering a modern fit and sharp style, perfect for any formal event",
                catalog: "Available in 3-piece or 2-piece options, stain-resistant, machine washable",
                promotion: "Bundle with a shirt and get 10% off, limited-time flash sale"
                
            ),
            Product(
                id: "female-jeans-001",
                name: "Womens Jeans",
                price: 29.99,
                imageName: "womens_jeans",
                description: "High-quality denim jeans designed for comfort and durability with a trendy fit",
                catalog: "Stretchable, high-rise fit, wide range of sizes",
                promotion: "Weekend sale - 15% off, Spend $100 and Save $20"
            ),
            Product(
                id: "mens-casual-dress-002",
                name: "Turtleneck Blazer",
                price: 49.99,
                imageName: "mens_casual_turtleneck",
                description: "A sleek black turtleneck paired with a tailored blazer, offering sophistication for casual and semi-formal events.",
                catalog: "High-quality fabric, tailored fit, available in multiple sizes.",
                promotion: "Get 10% off for New Year's Special!"
            ),
            Product(
                id: "mens-casual-dress-003",
                name: "Tie-Dye Hoodie",
                price: 39.99,
                imageName: "mens_tie_dye_hoodie",
                description: "Stylish and comfortable tie-dye hoodie perfect for cool weather and relaxed outings.",
                catalog: "Soft fleece lining, available in multiple sizes and designs.",
                promotion: "Flat 15% off for Winter Season!"
            ),
            Product(
                id: "female-stylish-top-002",
                name: "Abstract Art Long",
                price: 24.99,
                imageName: "womens_abstract_art_top",
                description: "Vibrant and eye-catching long sleeve top with a unique abstract art print, perfect for making a statement.",
                catalog: "High-quality polyester, fitted design, available in multiple sizes.",
                promotion: "New Arrival: 15% Off!"
            )
        ]
    }
    
    static func mockMostSearchedProducts() -> [Product] {
        return [
            Product(
                id: "teens-dress-001",
                name: "Teens Dress",
                price: 15.99,
                imageName: "teens_dress",
                description: "A chic and colorful dress perfect for casual outings or parties for teens",
                catalog: "Lightweight fabric, vibrant patterns, summer collection",
                promotion: "Buy 2 for $25, free gift wrapping"
            ),
            Product(
                id: "female-casual-jacket-003",
                name: "Blue Jacket",
                price: 39.99,
                imageName: "womens_blue_corduroy_jacket",
                description: "Stylish blue corduroy jacket paired with a matching top for a complete casual look.",
                catalog: "Soft and durable material, available in multiple sizes.",
                promotion: "Winter Special: Free Shipping on All Orders!"
            ),
            Product(
                id: "female-shirt-001",
                name: "Womens Shirt",
                price: 25.99,
                imageName: "womens_shirt",
                description: "A versatile shirt that combines style with comfort, suitable for casual or formal settings",
                catalog: "Breathable cotton, button-up style, pastel color options",
                promotion: "Early bird discount of 10%, extra loyalty points for members"
            ),
            Product(
                id: "mens-formal-dress-003",
                name: "Gray Vest Shirt",
                price: 59.99,
                imageName: "mens_gray_vest_shirt",
                description: "An elegant light gray vest with a matching formal shirt for office or formal events.",
                catalog: "Breathable fabric, wrinkle-resistant, available in all standard sizes.",
                promotion: "Buy 1 Get 1 50% off!"
            ),
            Product(
                id: "mens-allseason-dress-004",
                name: "Leopard Print Coat",
                price: 79.99,
                imageName: "mens_leopard_print_coat",
                description: "Stand out with this bold leopard print coat, ideal for adding flair to your winter wardrobe.",
                catalog: "Warm material, unique design, available in various sizes.",
                promotion: "Season-end Clearance: 20% off!"
            ),
            Product(
                id: "female-elegant-dress-004",
                name: "Turtleneck Outfit",
                price: 49.99,
                imageName: "womens_neutral_turtleneck_outfit",
                description: "Elegant turtleneck outfit featuring neutral tones, perfect for professional or semi-formal settings.",
                catalog: "Comfortable and breathable fabric, wrinkle-resistant, various sizes available.",
                promotion: "Holiday Sale: Flat 20% Off!"
            )
            
        ]
    }
    
    static func mockAllProducts() -> [Product] {
        return mockTrendingProducts() + mockMostSearchedProducts()
    }
}
