//
//  ScreenTrackingViewModifier.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/17/24.
//

// Utilities/ScreenTrackingViewModifier.swift

import SwiftUI
import Cdp
import SFMCSDK

struct ScreenTrackingViewModifier: ViewModifier {
    let screenName: String
    
    func body(content: Content) -> some View {
        content.onAppear {
            // Track screen view
            // Create a custom event for screen tracking
            if let event = CustomEvent(name: "ScreenView",
                                     attributes: ["screen_name": screenName]) {
                // Track the custom event
                SFMCSdk.track(event: event)
                print(screenName)
            }
        }
    }
}

extension View {
    func trackScreen(_ screenName: String) -> some View {
        modifier(ScreenTrackingViewModifier(screenName: screenName))
    }
}
