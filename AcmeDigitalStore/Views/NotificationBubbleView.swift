//
//  NotificationBubbleView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 12/9/24.
//

import SwiftUI

struct NotificationBubbleView: View {
//    @StateObject private var personalizationViewModel = EinsteinPersonalizationViewModel.shared
    @ObservedObject var personalizationViewModel: EinsteinPersonalizationViewModel
    @EnvironmentObject private var storeViewModel: StoreViewModel
    @State private var showPersonalizationModal = false
    private let logger = DataCloudLoggingService.shared
    
    var body: some View {
        Button(action: {
            showPersonalizationModal = true
        }) {
            ZStack(alignment: .topTrailing) {
                // Bell Icon with Dynamic Animation
                Image(systemName: personalizationViewModel.notificationCount > 0 ? "bell.badge.fill" : "bell.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(personalizationViewModel.notificationCount > 0 ? Color.red : Color.blue)
                            .animation(.easeInOut, value: personalizationViewModel.notificationCount)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                    )
                
                if personalizationViewModel.notificationCount > 0 {
                    Text("\(personalizationViewModel.notificationCount)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                        .padding(5)
                        .background(
                            Circle()
                                .fill(Color.blue)
                                .shadow(radius: 2)
                            )
                        .offset(x: 10, y: -10)
                        .transition(.scale.combined(with: .opacity))
                        .animation(.spring(), value: personalizationViewModel.notificationCount)
                }
            }
        }
        .sheet(isPresented: $showPersonalizationModal) {
            PersonalizationModalView(viewModel: personalizationViewModel)
        }
    }
}

struct PersonalizationModalView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: EinsteinPersonalizationViewModel
    @EnvironmentObject var storeViewModel: StoreViewModel
    @State private var selectedPersonalization: PersonalizationResponse.Personalization?
    private let logger = DataCloudLoggingService.shared
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    HeaderSection()
                        .padding(.top)
                    

                    if viewModel.personalizations.isEmpty {
                        EmptyStateView()
                    } else {
                        LazyVStack(spacing: 16) {
                            ForEach(viewModel.personalizations, id: \.personalizationId) { item in
                                PersonalizationCard(personalization: item)
                                    .transition(.slide)
                            }
                        }
                    }
                    
                    RefreshButton(storeViewModel: storeViewModel, dismiss: dismiss)
                        .padding(.bottom)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .onAppear {
            // Only call if there's a decision ID set
            if !viewModel.currentDecisionId.isEmpty {
                logger.debug("Checking notifications for \(viewModel.currentDecisionId)")
                viewModel.checkNotifications(decisionId: viewModel.currentDecisionId)
            }
            
        }
    }
}
//struct PersonalizationModalView: View {
//    @Environment(\.dismiss) private var dismiss
//    @ObservedObject var viewModel: EinsteinPersonalizationViewModel
//    @EnvironmentObject var storeViewModel: StoreViewModel
//    @State private var selectedPersonalization: PersonalizationResponse.Personalization?
//    
//    var body: some View {
//        NavigationView {
//            ScrollView {
//                VStack(spacing: 20) {
//                    // Header Section
//                    HeaderSection()
//                    
//                    // Personalization Cards
//                    ForEach(viewModel.personalizations, id: \.personalizationId) { item in
//                        PersonalizationCard(personalization: item)
//                    }
//                    
//                    // Refresh Button
//                    RefreshButton(storeViewModel: storeViewModel, dismiss: dismiss)
//                }
//                .padding()
//            }
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Done") { dismiss() }
//                }
//            }
//        }
////        .onAppear {
////            viewModel.checkNotifications(decisionId: String)
////        }
//    }
//}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No New Notifications")
                .font(.headline)
            
            Text("Check back later for personalized recommendations")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 50)
    }
}

struct HeaderSection: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("Personalization")
                .font(.title.bold())
            
            Text("Discover products tailored for you")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}



struct PersonalizationCard: View {
    let personalization: PersonalizationResponse.Personalization
    
    
    
    private var categoryImage: String {
        if let header = personalization.attributes["Header"]?.lowercased() {
            switch header {
            case "mens":
                return "mens_fashion_personalization"  // Image asset name for mens category
            case "womens":
                return "womens_fashion_personalization"  // Image asset name for womens category
            default:
                return "default-category-banner"  // Default fallback image
            }
        }
        return "default-category-banner"
    }
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Header
            Text(personalization.attributes["Header"] ?? "")
                .font(.headline)
            
            // Subheader
            if let subheader = personalization.attributes["Subheader"], !subheader.isEmpty {
                Text(subheader)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            // Local Image from Assets
            Image(categoryImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Call to Action
            if let ctaText = personalization.attributes["CallToActionText"],
               let ctaUrl = personalization.attributes["CallToActionUrl"],
               !ctaText.isEmpty,
               let url = URL(string: ctaUrl) {
                Link(destination: url) {
                    Text(ctaText)
                        .font(.callout.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            
            // Metadata
            Text("ID: \(personalization.personalizationPointName)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .gray.opacity(0.2), radius: 8, x: 0, y: 2)
        )
    }
}


struct RefreshButton: View {
    let storeViewModel: StoreViewModel
    let dismiss: DismissAction
    
    var body: some View {
        Button(action: {
            storeViewModel.fetchPersonalizedProducts()
            dismiss()
        }) {
            HStack {
                Image(systemName: "sparkles")
                Text("Refresh Recommendations")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue.gradient)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }
}
