//
//  ReviewsView.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI

struct ReviewsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Customer Reviews")
                    .font(.largeTitle)
                    .padding()
                
                // Add your reviews content here
                List {
                    Text("Review 1: Great product!")
                    Text("Review 2: Fast shipping!")
                    // Add more reviews as needed
                }
            }
            .navigationTitle("Reviews")
        }
        .trackScreen("ReviewsScreenView")
    }
}
