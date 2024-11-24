//
//  LocationTrackingService.swift
//  AcmeDigitalStore
//
//  Created by Arup Sarkar (TA) on 11/18/24.
//

import Foundation
import CoreLocation
import SFMCSDK
import Cdp


final class LocationTrackingService: NSObject {
    static let shared = LocationTrackingService()
    
    private let locationManager = CLLocationManager()
    private let logger = DataCloudLoggingService.shared
    private let expirationTime: Int = 60 // Location expiration in seconds
    
    private override init() {
        super.init()
        setupLocationManager()
    }
    
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.distanceFilter = 100
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startTracking() {
        let authStatus = locationManager.authorizationStatus
        
        switch authStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
            logger.debug("Location tracking started")
        case .notDetermined:
            requestLocationPermission()
        case .restricted, .denied:
            logger.error("Location permission denied")
        @unknown default:
            logger.error("Unknown location authorization status")
        }
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        // Clear location from CDP module
        CdpModule.shared.setLocation(coordinates: nil, expiresIn: 0)
        logger.debug("Location tracking stopped")
    }
    
    private func updateCDPLocation(_ location: CLLocation) {
        guard let coordinates = CdpCoordinates(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        ) else {
            logger.error("Invalid coordinates")
            return
        }
        
        CdpModule.shared.setLocation(
            coordinates: coordinates,
            expiresIn: expirationTime
        )
        
        logger.debug("CDP location updated: lat: \(coordinates.latitude), lon: \(coordinates.longitude)")
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationTrackingService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        updateCDPLocation(location)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        logger.error("Location update failed: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startTracking()
        case .denied, .restricted:
            stopTracking()
        default:
            break
        }
    }
}


#if DEBUG
extension LocationTrackingService {
    func simulateLocation(latitude: Double, longitude: Double) {
        guard let coordinates = CdpCoordinates(
            latitude: latitude,
            longitude: longitude
        ) else {
            logger.error("Invalid test coordinates")
            return
        }
        
        CdpModule.shared.setLocation(
            coordinates: coordinates,
            expiresIn: expirationTime
        )
        
        logger.debug("Simulated location set: \(latitude), \(longitude)")
    }
}
#endif
