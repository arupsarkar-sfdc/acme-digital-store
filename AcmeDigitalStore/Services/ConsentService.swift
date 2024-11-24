//
//  ConsentService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

// Services/ConsentService.swift

import Cdp
import SFMCSDK

final class ConsentService {
    static let shared = ConsentService()
    
    private init() {}
    
    func setConsent(isOptedIn: Bool) {
        if isOptedIn {
            CdpModule.shared.setConsent(consent: Consent.optIn)
        } else {
            CdpModule.shared.setConsent(consent: Consent.optOut)
        }
    }
    
    func getCurrentConsent() -> Consent {
        return CdpModule.shared.getConsent()
    }
}
