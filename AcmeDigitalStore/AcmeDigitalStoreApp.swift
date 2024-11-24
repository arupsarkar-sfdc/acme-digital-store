//
//  AcmeDigitalStoreApp.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar on 10/23/24.
//

import SwiftUI
import Cdp
import SFMCSDK

@main
struct AcmeDigitalStoreApp: App {
    @AppStorage("hasConsented") private var hasConsented: Bool = false
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    init() {}
    
    var body: some Scene {
        WindowGroup {
            if hasConsented {
                ContentView()
            } else {
                ConsentView()
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//        // Initialize services
        _ = DataCloudService.shared
//        _ = ProfileDataService.shared
        LocationTrackingService.shared.requestLocationPermission()
        return true
    }
}
