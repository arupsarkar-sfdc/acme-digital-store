//
//  StoreViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import Foundation
import SFMCSDK

class StoreViewModel: ObservableObject {
    @Published var trendingProducts: [Product] = []
    @Published var mostSearchedProducts: [Product] = []
    @Published var shoppingCart: [CartItem] = []
    @Published var searchResults: [Product] = []
    @Published var searchText: String = ""
    private let logger = DataCloudLoggingService.shared
    private let locationService = LocationTrackingService.shared
    
    private let engagementService = EngagementTrackingService.shared
    
    func checkSdkState() {
        // Option 1: Get the state directly
        if let state = logger.getSdkState() {
            print("Current SDK State: \(state)")
        }
    }
    func startLocationTracking() {
        locationService.startTracking()
    }
    
    func stopLocationTracking() {
        locationService.stopTracking()
    }
    
    
    init() {
        print("Checking sdk start - Start")
        checkSdkState()
        startLocationTracking()
        print("Checking sdk start - End")
        fetchTrendingProducts()
        fetchMostSearchedProducts()
    }
    
    func fetchTrendingProducts() {
        // Fetch trending products (Mocked data for now)
        trendingProducts = Product.mockTrendingProducts()
    }
    
    func fetchMostSearchedProducts() {
        // Fetch most searched products (Mocked data for now)
        mostSearchedProducts = Product.mockMostSearchedProducts()
    }
    
    func fetchSearchResults() {
        // Query the mock product database based on the search text
        searchResults = Product.mockAllProducts().filter { product in
            product.name.lowercased().contains(searchText.lowercased())
        }
        // Notify the UI about updates
        objectWillChange.send()
//        // Mocked search results based on the search text
//        searchResults = Product.mockAllProducts().filter { product in
//            product.name.lowercased().contains(searchText.lowercased())
//        }

    }
    
    func authenticateUser() {
        // Implement user authentication (Sign-in/Sign-up)
    }
    
    func addToCart(product: Product) {
        if let index = shoppingCart.firstIndex(where: { $0.product.id == product.id }) {
            shoppingCart[index].quantity += 1
            trackAddToCart(product: product, quantity: shoppingCart[index].quantity)
        } else {
            shoppingCart.append(CartItem(product: product, quantity: 1))
            trackAddToCart(product: product, quantity: 1)
        }
    }
    
    func removeFromCart(product: Product) {
        if let index = shoppingCart.firstIndex(where: { $0.product.id == product.id }) {
            trackRemoveFromCart(product: product, quantity: shoppingCart[index].quantity)
            shoppingCart.remove(at: index)
        }
    }
    
    private func trackAddToCart(product: Product, quantity: Int) {
        
        let lineItem = LineItem(
            catalogObjectType: "Product",
            catalogObjectId: product.id.uuidString,
            quantity: quantity,
            price: NSDecimalNumber(value: product.price),
            currency: "USD",
            attributes: [
                "name": product.name,
                "category": product.name
            ]
        )
        logger.debug("addToCart - lineItem: \(lineItem.catalogObjectId)")
        let event = AddToCartEvent(lineItem: lineItem)
        SFMCSdk.track(event: event)
    }
    
    private func trackRemoveFromCart(product: Product, quantity: Int) {
        let lineItem = LineItem(
            catalogObjectType: "Product",
            catalogObjectId: product.id.uuidString,
            quantity: quantity
        )
        logger.debug("removeToCart - lineItem: \(lineItem.catalogObjectId)")
        let event = RemoveFromCartEvent(lineItem: lineItem)
        SFMCSdk.track(event: event)
    }
    
}
