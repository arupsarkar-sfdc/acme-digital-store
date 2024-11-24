//
//  ContentView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//
//
//https://developer.salesforce.com/docs/atlas.en-us.c360a_api.meta/c360a_api/c360a_api_engagement_mobile_sdk.htm



import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = StoreViewModel()
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6 // Light accent color
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
//            ShoppingCartView(cart: $viewModel.shoppingCart, viewModel: viewModel)
//                            .tabItem {
//                                Image(systemName: "cart.fill")
//                                Text("Cart")
//                            }
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Account")
                }
            ReviewsView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("Reviews")
                }
            
        }
        .accentColor(.blue)
    }
}

#Preview {
    ContentView()
}
