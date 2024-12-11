//
//  HomeView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = StoreViewModel()
    @State private var showProfileModal = false
    @StateObject private var personalizationViewModel = EinsteinPersonalizationViewModel()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 0) {
                
                // Modern Header
                VStack(alignment: .leading, spacing: 12) {
                    Text("Acme Store")
                        .font(.largeTitle.bold())
//                    Text("Discover Amazing Products")
//                        .font(.title2.weight(.semibold))
//                        .foregroundStyle(.primary)
                    Text("Shop with confidence")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color(.systemBackground))
                
                
                SearchBar(text: $viewModel.searchText, viewModel: viewModel)
                if viewModel.searchText.isEmpty {
                    ScrollView {
                        VStack(spacing: 20) {
                            TrendingProductsView(trendingProducts: viewModel.trendingProducts, viewModel: viewModel)
                            MostSearchedView(mostSearchedProducts: viewModel.mostSearchedProducts, viewModel: viewModel)
                        }
                    }
                } else {
                    SearchResultsView(results: viewModel.searchResults, viewModel: viewModel)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .trackScreen("HomeView")
            
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showProfileModal.toggle() // Toggle modal instead of authenticateUser
                    }) {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                }
                
                ToolbarItem(placement: .principal) {
                                    NotificationBubbleView()
                                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ShoppingCartView(cart: $viewModel.shoppingCart, viewModel: viewModel)) {
                        ZStack(alignment: .topTrailing) {
                            Image(systemName: "cart.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.white)
                                .background(Circle().fill(Color.blue))
                            
                            if viewModel.shoppingCart.count > 0 {
                                Text("\(viewModel.shoppingCart.count)")
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Color.red)
                                    .clipShape(Circle())
                                    .offset(x: 10, y: -10)
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $showProfileModal) {
                ProfileFormView()
            }
        }
        .environmentObject(viewModel)

        
        
    }
}

