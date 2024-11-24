//
//  PrivacySettingsViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//
import Foundation
import Combine
import SwiftUI

final class PrivacySettingsViewModel: ObservableObject {
    @Published var isDataCollectionEnabled = false
    @Published var token: TokenResponse.Token?
    @Published var errorMessage: String?
    @AppStorage("storedAccessToken") private var storedAccessToken: String = ""
    @AppStorage("storedInstanceUrl") private var storedInstanceUrl: String = ""
    @AppStorage("storedExpiresIn") private var storedExpiresIn: Int = 0
    @AppStorage("storedIssuedTokenType") private var storedIssuedTokenType: String = ""
    @AppStorage("storedTokenType") private var storedTokenType: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private let tokenService = TokenService.shared
    
    // Update token storage when received
    private func storeToken(_ token: TokenResponse.Token) {
        storedAccessToken = token.accessToken
        storedInstanceUrl = token.instanceUrl
        storedExpiresIn = token.expiresIn
        storedIssuedTokenType = token.issuedTokenType
        storedTokenType = token.tokenType
    }
    
    func fetchToken() {
        tokenService.fetchToken()
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] response in
                    self?.token = response.token
                    self?.storeToken(response.token)
                }
            )
            .store(in: &cancellables)
    }
}
