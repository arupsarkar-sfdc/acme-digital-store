//
//  ConfigurationManager.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/17/24.
//

final class ConfigurationManager {
    static let shared = ConfigurationManager()
    
    private init() {}
    
    // Add these to your configuration file or environment variables
    var cdpAppId: String {
        // Replace with your actual app ID
        return "c4eb02b4-31dc-4728-841f-e0bfaf02d21f"
    }
    
    var cdpEndpoint: String {
        // Replace with your actual endpoint
        return "mnrw0zbyh0yt0mldmmytqzrxg0.c360a.salesforce.com"
    }
}
