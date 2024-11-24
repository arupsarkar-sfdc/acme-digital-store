//
//  LocationAwareViewModifier.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

// Utilities/LocationAwareViewModifier.swift

import SwiftUI

struct LocationAwareViewModifier: ViewModifier {
    let locationService = LocationTrackingService.shared
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                locationService.startTracking()
            }
            .onDisappear {
                locationService.stopTracking()
            }
    }
}

extension View {
    func locationAware() -> some View {
        modifier(LocationAwareViewModifier())
    }
}
