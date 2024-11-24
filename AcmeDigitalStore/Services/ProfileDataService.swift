//
//  ProfileDataService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//




import Foundation
import SFMCSDK
import Cdp
import AdSupport
import AppTrackingTransparency

final class ProfileDataService {
    static let shared = ProfileDataService()
    private let logger = DataCloudLoggingService.shared
    private let dataCloudService = DataCloudService.shared
    @Published private(set) var isKnownUser = false
    
    private init() {
        // Register for data cloud state changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDataCloudStateChange),
            name: .dataCloudStateChanged,
            object: nil
        )
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func handleDataCloudStateChange(_ notification: Notification) {
        guard let event = notification.userInfo?[Notification.dataCloudEventKey] as? DataCloudEvent else {
            return
        }
        
        switch event {
        case .initialized:
            logger.debug("Received CDP Module initialized event")
            // Module is guaranteed to be operational when event is received
            initializeProfile()
            
        case .failed(let error):
            if let error = error {
                logger.error("CDP Module initialization failed: \(error.localizedDescription)")
            } else {
                logger.error("CDP Module initialization failed")
            }
        }
    }
    
    private func initializeProfile() {
        setAnonymousProfile()
        requestTrackingAuthorization()
    }
    
    
    @objc private func handleSdkInitialization() {
        // Only proceed if SDK is operational
//        guard dataCloudService.isCdpModuleOperational() else {
//            logger.error("CDP Module not operational")
//            return
//        }
        
        // Start with anonymous profile
        setAnonymousProfile()
        // Request tracking authorization
        requestTrackingAuthorization()
    }
    
    // MARK: - Tracking Authorization
    private func requestTrackingAuthorization() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                switch status {
                case .authorized:
                    self?.captureDeviceInformation()
                case .denied, .restricted, .notDetermined:
                    self?.logger.debug("Tracking authorization denied or restricted")
                @unknown default:
                    break
                }
            }
        } else {
            captureDeviceInformation()
        }
    }
    
    // MARK: - Anonymous Profile
    func setAnonymousProfile() {
//        guard dataCloudService.isCdpModuleOperational() else {
//            logger.error("CDP Module not operational")
//            return
//        }
        
        CdpModule.shared.setProfileToAnonymous()
        isKnownUser = false
        logger.debug("Profile set to anonymous")
    }
    
    // MARK: - Known Profile
    func setKnownProfile(firstName: String, lastName: String, email: String) {
//        guard dataCloudService.isCdpModuleOperational() else {
//            logger.error("CDP Module not operational")
//            return
//        }
        
        CdpModule.shared.setProfileToKnown()
        isKnownUser = true
        
        let attributes: [String: String] = [
            "firstName": firstName,
            "lastName": lastName,
            "email": email
        ]
        
        SFMCSdk.identity.setProfileAttributes(attributes)
        logger.debug("Profile set to known with basic attributes")
        captureDeviceInformation()
    }
    
    // MARK: - Device Information
    func captureDeviceInformation() {
//        guard dataCloudService.isCdpModuleOperational() else {
//            logger.error("CDP Module not operational")
//            return
//        }
        
        var deviceAttributes: [String: String] = [
            "deviceType": UIDevice.current.model,
            "softwareApplicationName": Bundle.main.appName
        ]
        
        // Add advertiser ID if tracking is authorized
        if #available(iOS 14, *) {
            if ATTrackingManager.trackingAuthorizationStatus == .authorized {
                deviceAttributes["advertiserId"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        } else {
            if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
                deviceAttributes["advertiserId"] = ASIdentifierManager.shared().advertisingIdentifier.uuidString
            }
        }
        
        SFMCSdk.identity.setProfileAttributes(deviceAttributes)
        logger.debug("Device information captured")
    }
    
    // MARK: - Contact Information
    func updateContactInformation(phone: String? = nil, address: Address? = nil) {
//        guard dataCloudService.isCdpModuleOperational() else {
//            logger.error("CDP Module not operational")
//            return
//        }
        
        var contactAttributes: [String: String] = [:]
        
        if let phone = phone {
            contactAttributes["phoneNumber"] = phone
        }
        
        if let address = address {
            contactAttributes["addressLine1"] = address.line1
            contactAttributes["city"] = address.city
            contactAttributes["stateProvince"] = address.state
            contactAttributes["postalCode"] = address.postalCode
            contactAttributes["country"] = address.country
        }
        
        if !contactAttributes.isEmpty {
            SFMCSdk.identity.setProfileAttributes(contactAttributes)
            logger.debug("Contact information updated")
        }
    }
}

private extension Bundle {
    var appName: String {
        return object(forInfoDictionaryKey: "CFBundleName") as? String ?? "Acme Digital Store"
    }
}
