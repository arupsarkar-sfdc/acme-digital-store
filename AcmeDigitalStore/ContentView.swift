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
        appearance.backgroundColor = UIColor.systemGray6
        
        // Reduce the tab bar height
        appearance.stackedLayoutAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        appearance.stackedLayoutAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
        
        
        UITabBar.appearance().standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
        
        // Set smaller default height
        UITabBar.appearance().bounds.size.height = 50
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            AccountView()
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Account")
                }
            ChatView()
                .tabItem {
                    Image(systemName: "message.circle.fill")
                    Text("Agentforce")
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
