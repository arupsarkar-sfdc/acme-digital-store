//
//  SignUpViewModel.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    private let profileService = ProfileDataService.shared
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    
    init() {
        // Device information will be captured automatically when tracking is authorized
        profileService.setAnonymousProfile()
    }
    
    func handleSignUp() {
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty else {
            return
        }
        
        profileService.setKnownProfile(
            firstName: firstName,
            lastName: lastName,
            email: email
        )
    }
    
    func updateAddress(address: Address) {
        profileService.updateContactInformation(address: address)
    }
    
    func updatePhone(phone: String) {
        profileService.updateContactInformation(phone: phone)
    }
}
