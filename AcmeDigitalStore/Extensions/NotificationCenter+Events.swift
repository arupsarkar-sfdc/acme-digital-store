//
//  NotificationCenter+Events.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/19/24.
//

import Foundation

extension Notification.Name {
    static let dataCloudStateChanged = Notification.Name("com.acmedigitalstore.datacloud.stateChanged")
}

extension Notification {
    static let dataCloudEventKey = "dataCloudEvent"
}
