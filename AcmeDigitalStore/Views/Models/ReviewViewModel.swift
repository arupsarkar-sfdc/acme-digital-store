//
//  ReviewViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//

import Foundation
import Combine
import UIKit
import SwiftUI

final class ReviewViewModel: ObservableObject {
    @Published var selectedCategory: ReviewCategory = .product
    @Published var rating: Int = 0
    @Published var comment: String = ""
    @Published var isSubmitting = false
    @Published var showSuccess = false
    @Published var errorMessage: String?
    
    @AppStorage("storedAccessToken") private var storedAccessToken: String = ""
    @AppStorage("storedInstanceUrl") private var storedInstanceUrl: String = ""
    @AppStorage("storedExpiresIn") private var storedExpiresIn: Int = 0
    @AppStorage("storedIssuedTokenType") private var storedIssuedTokenType: String = ""
    @AppStorage("storedTokenType") private var storedTokenType: String = ""
    @AppStorage("unifiedIndividualId") private var unifiedIndividualId: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let reviewService = ReviewService.shared
    private let logger = DataCloudLoggingService.shared
    
    var canSubmit: Bool {
        rating > 0 && !comment.isEmpty
    }
    
    private var hasValidToken: Bool {
        !storedAccessToken.isEmpty && !storedInstanceUrl.isEmpty
    }
    
    func submitReview() {
        guard hasValidToken else {
            logger.debug("No token available for submission")
            return
        }
        //get the contact id of the user from app storage
        let unifiedId = unifiedIndividualId
        //get the token identifiers from the app storage
        let token = TokenResponse.Token(
            accessToken: storedAccessToken,
            expiresIn: storedExpiresIn,
            instanceUrl: storedInstanceUrl,
            issuedTokenType: storedIssuedTokenType,
            tokenType: storedTokenType
        )
        guard canSubmit else { return }
        
        isSubmitting = true
        
        let customerReview = CustomerReview(
            category: selectedCategory.rawValue,
            review_date_time: ISO8601DateFormatter().string(from: Date()),
            data_source: "acme digital store",
            data_source_object: "acme digital store mobile",
            device_id: UIDevice.current.identifierForVendor?.uuidString ?? "unknown",
            device_type: "mobile",
            internal_org: "dcunited-home-org",
            rating: rating,
            feedback: comment,
            review_id: UUID().uuidString,
            unified_individual_id: unifiedId
        )
        
        logger.debug(customerReview.category)
        logger.debug(customerReview.review_date_time)
        logger.debug(customerReview.device_id)
        logger.debug(customerReview.feedback)
        logger.debug(unifiedId)
        
        let payload = ReviewPayload(data: [customerReview])
        
        reviewService.submitReview(payload, token: token)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isSubmitting = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] in
                    self?.showSuccess = true
                    self?.resetForm()
                }
            )
            .store(in: &cancellables)
    }
    
    private func resetForm() {
        rating = 0
        comment = ""
    }
}
