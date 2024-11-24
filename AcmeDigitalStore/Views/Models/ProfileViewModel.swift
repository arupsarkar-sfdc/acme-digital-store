//
//  ProfileViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/23/24.
//
import Combine
import SwiftUI

final class ProfileViewModel: ObservableObject {
    @Published var profileId: String = ""
    @Published var profile: ProfileData?
    @Published var errorMessage: String?
    @Published var isLoading = false
    private let logger = DataCloudLoggingService.shared
    
    private var cancellables = Set<AnyCancellable>()
    private let profileService = ProfileService.shared
    @AppStorage("unifiedIndividualId") private var unifiedIndividualId: String = ""
    
    
    private func storeUnifiedIndividualId(_ unifiedId: String) {
        unifiedIndividualId = unifiedId
    }
    
    func fetchProfile(accessToken: String, instanceUrl: String) {
        guard !profileId.isEmpty else { return }
        
        logger.debug("token : \(accessToken)")
        logger.debug("instanceUrl  : \(instanceUrl)")
        
        isLoading = true
        profileService.fetchProfile(
            id: profileId,
            accessToken: accessToken,
            instanceUrl: instanceUrl
        )
        .sink(
            receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            },
            receiveValue: { [weak self] response in
                if let firstProfile = response.data.first {
                    self?.profile = firstProfile
                    self?.storeUnifiedIndividualId(self?.profile?.externalRecordId ?? "unknown")
                }
            }
        )
        .store(in: &cancellables)
    }
}
