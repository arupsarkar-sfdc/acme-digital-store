//
//  EinsteinPersonalizationViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 12/9/24.
//

import Foundation
import Combine
import UIKit

final class EinsteinPersonalizationViewModel: ObservableObject {
    
    static let shared = EinsteinPersonalizationViewModel()
    @Published var notificationCount: Int = 0
    @Published var personalizations: [PersonalizationResponse.Personalization] = []
    @Published var showNotification: Bool = false
    
    @Published private var productClickCount: Int {
        didSet {
            UserDefaults.standard.set(productClickCount, forKey: "productClickCount")
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private let einsteinPersonalizationService = EinsteinPersonalizationService.shared
    // declare a variable decisionId
    private let logger = DataCloudLoggingService.shared
    @Published var currentDecisionId: String = ""
    
    init() {
        // Initialize productClickCount from UserDefaults
        self.productClickCount = UserDefaults.standard.integer(forKey: "productClickCount")
    }
    private func resetClickCount() {
        productClickCount = 0
        UserDefaults.standard.set(0, forKey: "productClickCount")
    }
    
    func trackProductClick(productName: String) {
        if productName.lowercased().contains("mens") {
            productClickCount += 1
            logger.debug("mens product clicked: \(productName) - \(productClickCount)")
            if productClickCount >= 4 {
                currentDecisionId = "9pbal0000000rcDAAQ"
                checkNotifications(decisionId: currentDecisionId)
                resetClickCount()
                showNotification = true // Trigger notification visibility

            }
        } else if productName.lowercased().contains("female") {
            productClickCount += 1
            logger.debug("womens product clicked: \(productName) - \(productClickCount)")
            if productClickCount >= 4 {
                currentDecisionId = "9pbal0000000rifAAA"
                checkNotifications(decisionId: currentDecisionId)
                resetClickCount()
                showNotification = true // Trigger notification visibility
            }
        }
    }
    
    func checkNotifications(decisionId: String) {
        logger.debug("invoking checkNotifications with decisionId: \(decisionId)")
        let token = TokenResponse.Token(
            accessToken: UserDefaults.standard.string(forKey: "storedAccessToken") ?? "",
            expiresIn: UserDefaults.standard.integer(forKey: "storedExpiresIn"),
            instanceUrl: UserDefaults.standard.string(forKey: "storedInstanceUrl") ?? "",
            issuedTokenType: UserDefaults.standard.string(forKey: "storedIssuedTokenType") ?? "",
            tokenType: UserDefaults.standard.string(forKey: "storedTokenType") ?? ""
        )
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        
        
        einsteinPersonalizationService
            .fetchNotifications(
                token: token,
                individualId: deviceId,
                decisionId: decisionId
            )
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] response in
                    self?.personalizations = response.personalizations
                    self?.notificationCount = response.personalizations.count
                    self?.showNotification = true
                }
                
            )
            .store(in: &cancellables)
    }
}
