//
//  ReviewsView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI

// MARK: - Views
struct ReviewsView: View {
    @StateObject private var viewModel = ReviewViewModel()
    @State private var showingForm = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Header Section
                HeaderView()
                
                // Main Content
                ScrollView {
                    VStack(spacing: 20) {
                        ReviewTypeButtons(viewModel: viewModel)
                        RatingView(rating: $viewModel.rating)
                        CommentSection(comment: $viewModel.comment)
                        
                        SubmitButton(viewModel: viewModel)
                    }
                    .padding()
                }
            }
//            .navigationTitle("Reviews")
            .alert("Success", isPresented: $viewModel.showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Thank you for your feedback!")
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
        }
    }

}

struct ReviewTypeButtons: View {
    @ObservedObject var viewModel: ReviewViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What would you like to review?")
                .font(.headline)
            
            ForEach(ReviewCategory.allCases, id: \.self) { category in
                Button(action: { viewModel.selectedCategory = category }) {
                    HStack {
                        Text(category.rawValue)
                            .foregroundColor(viewModel.selectedCategory == category ? .white : .primary)
                        Spacer()
                    }
                    .padding()
                    .background(viewModel.selectedCategory == category ? Color.blue : Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
            }
        }
    }
}

struct SubmitButton: View {
    @ObservedObject var viewModel: ReviewViewModel
    let logger = DataCloudLoggingService.shared
    
    var body: some View {
        
        Button(action: {
            logger.debug("Submit button tapped")
            viewModel.submitReview()
        }) {
            HStack {
                if viewModel.isSubmitting {
                    ProgressView()
                        .tint(.white)
                }
                Text(viewModel.isSubmitting ? "Submitting..." : "Submit Review")
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(viewModel.canSubmit ? Color.blue : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(!viewModel.canSubmit || viewModel.isSubmitting)
        .onChange(of: viewModel.isSubmitting) { oldValue, newValue in
            logger.debug("Submission state changed from \(oldValue) to \(newValue)")
        }
    }
}

// MARK: - Supporting Views
struct HeaderView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Reviews")
                .font(.largeTitle.bold())
            Text("We Value Your Feedback")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)
            Text("Help us improve our services")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
}


struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Rating")
                .font(.headline)
            HStack {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(index <= rating ? .yellow : .gray)
                        .font(.title2)
                        .onTapGesture {
                            rating = index
                        }
                }
            }
        }
    }
}


struct CommentSection: View {
    @Binding var comment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your Feedback")
                .font(.headline)
            TextEditor(text: $comment)
                .frame(height: 100)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.2)))
        }
    }
}



struct ProductIdField: View {
    @Binding var productId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Product ID")
                .font(.headline)
            TextField("Enter Product ID", text: $productId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
        }
    }
}

struct TransactionIdField: View {
    @Binding var transactionId: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Transaction ID")
                .font(.headline)
            TextField("Enter Transaction ID", text: $transactionId)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
        }
    }
}
