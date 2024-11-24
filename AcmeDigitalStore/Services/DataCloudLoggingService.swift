//
//  DataCloudLoggingService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

import Foundation
import SFMCSDK

class DataCloudLoggingService {
    static let shared = DataCloudLoggingService()

    // Using LoggerCategory.module for dynamic category selection
    private let category: LoggerCategory = .module
    private let subsystem: LoggerSubsystem = .sdk
    
    private init() {

        // Set logging level for debug mode
        #if DEBUG
        SFMCSdk.setLogger(logLevel: LogLevel.debug)
        #else
        SFMCSdk.setLogger(LogLevel.error)
        #endif
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function) {
        SFMCSdkLogger.shared.logMessage(
            level: .debug,
            subsystem: subsystem,
            category: category,
            message: "\(function): \(message)"
        )
    }
    
    func warning(_ message: String, file: String = #file, function: String = #function) {
        SFMCSdkLogger.shared.logMessage(
            level: .warn,
            subsystem: subsystem,
            category: category,
            message: "\(function): \(message)"
        )
    }
    
    func error(_ message: String, file: String = #file, function: String = #function) {
        SFMCSdkLogger.shared.logMessage(
            level: .error,
            subsystem: subsystem,
            category: category,
            message: "\(function): \(message)"
        )
    }
    
    
    
    func getSdkState() -> String? {
        var state: String?
        state = SFMCSdk.state()
        return state
    }
    

}
