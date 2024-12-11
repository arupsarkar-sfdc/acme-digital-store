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
    
    @Published var notificationCount: Int = 0
    @Published var personalizations: [PersonalizationResponse.Personalization] = []
    private var cancellables = Set<AnyCancellable>()
    private let einsteinPersonalizationService = EinsteinPersonalizationService.shared
    
    func checkNotifications() {
        
        let token = TokenResponse.Token(
            accessToken: UserDefaults.standard.string(forKey: "storedAccessToken") ?? "",
            expiresIn: UserDefaults.standard.integer(forKey: "storedExpiresIn"),
            instanceUrl: UserDefaults.standard.string(forKey: "storedInstanceUrl") ?? "",
            issuedTokenType: UserDefaults.standard.string(forKey: "storedIssuedTokenType") ?? "",
            tokenType: UserDefaults.standard.string(forKey: "storedTokenType") ?? ""
        )
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        
        
        einsteinPersonalizationService.fetchNotifications(token: token, individualId: deviceId)
//            .map { response -> Int in
//                       // Convert PersonalizationResponse to notification count
//                       response.personalizations.count
//                   }
            .sink(
                receiveCompletion: { _ in },
//                receiveValue: { [weak self] count in
//                    self?.notificationCount = count
//                }
                receiveValue: { [weak self] response in
                    self?.personalizations = response.personalizations
                    self?.notificationCount = response.personalizations.count
                }
                
            )
            .store(in: &cancellables)
    }
}
