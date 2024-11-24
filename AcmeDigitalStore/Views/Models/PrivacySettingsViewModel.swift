//
//  PrivacySettingsViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//
import Foundation
import Combine

final class PrivacySettingsViewModel: ObservableObject {
    @Published var isDataCollectionEnabled = false
    @Published var token: TokenResponse.Token?
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    private let tokenService = TokenService.shared
    
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
                }
            )
            .store(in: &cancellables)
    }
}
