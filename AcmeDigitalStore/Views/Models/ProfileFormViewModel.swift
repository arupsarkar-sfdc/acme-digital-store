//
//  ProfileFormViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//


import Foundation
import Combine

final class ProfileFormViewModel: ObservableObject {
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var showSuccess = false
    
    private let profileService = ProfileDataService.shared
    private var cancellables = Set<AnyCancellable>()
    
    var isValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        !email.isEmpty &&
        email.contains("@")
    }
    
    func submitProfile() {
        profileService.setKnownProfile(
            firstName: firstName,
            lastName: lastName,
            email: email
        )
        showSuccess = true
    }
}
