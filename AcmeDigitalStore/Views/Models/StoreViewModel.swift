//
//  StoreViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import Foundation
import SFMCSDK
import Combine

class StoreViewModel: ObservableObject {
    @Published var trendingProducts: [Product] = []
    @Published var mostSearchedProducts: [Product] = []
    @Published var shoppingCart: [CartItem] = []
    @Published var searchResults: [Product] = []
    @Published var searchText: String = ""
    
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    private let logger = DataCloudLoggingService.shared
    private let locationService = LocationTrackingService.shared
    
    private let engagementService = EngagementTrackingService.shared
    private let personalizationService = EinsteinPersonalizationService.shared
    private var cancellables = Set<AnyCancellable>()
    
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
    
    func fetchPersonalizedProducts() {
        logger.debug("Starting personalization fetch")

        let token = TokenResponse.Token(
            accessToken: UserDefaults.standard.string(forKey: "storedAccessToken") ?? "",
            expiresIn: UserDefaults.standard.integer(forKey: "storedExpiresIn"),
            instanceUrl: UserDefaults.standard.string(forKey: "storedInstanceUrl") ?? "",
            issuedTokenType: UserDefaults.standard.string(forKey: "storedIssuedTokenType") ?? "",
            tokenType: UserDefaults.standard.string(forKey: "storedTokenType") ?? ""
        )
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
              logger.debug("Device ID for personalization: \(deviceId)")

        personalizationService.fetchNotifications(
            token: token, individualId: deviceId
        )
            .receive(on: DispatchQueue.main)
            .handleEvents(
                receiveSubscription: { [weak self] _ in
                    self?.isLoading = true
                    self?.logger.debug("Personalization request started")
                },
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.logger.debug("Personalization request failed: \(error.localizedDescription)")
                        self?.errorMessage = error.localizedDescription
                    }
                }
            )
            .sink(
                receiveCompletion: { [weak self] completion in
                              if case .failure(let error) = completion {
                                  self?.logger.debug("Error: \(error)")
                              }
                          },
                          receiveValue: { [weak self] response in
                              self?.updateProductsWithPersonalization(response)
                          }
            )
            .store(in: &cancellables)

    }
    private func updateProductsWithPersonalization(_ response: PersonalizationResponse) {
        logger.debug("Processing personalization response")
        // Update products based on personalization response
        if let recommendations = response.personalizations.first?.data {
            // Update trending products based on recommendations
            // This is where you would map the personalization data to your product models
            logger.debug("Received \(recommendations.count) recommendations")
        }
    }
    
    func fetchSearchResults() {
        // Query the mock product database based on the search text
        searchResults = Product.mockAllProducts().filter { product in
            product.name.lowercased().contains(searchText.lowercased())
        }
        // Notify the UI about updates
        objectWillChange.send()
    }
    
    func emptyShoppingCart() {
        logger.debug("Clearing shopping cart.")
        shoppingCart.removeAll()
        objectWillChange.send()
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
