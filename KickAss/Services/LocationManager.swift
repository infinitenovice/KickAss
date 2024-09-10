//
//  LocationManager.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI
import CoreLocation
import OSLog

@Observable
class LocationManager: NSObject, CLLocationManagerDelegate {
    var log = Logger(subsystem: LOGSUBSYSTEM, category: "LocationManager")
    @ObservationIgnored  let manager = CLLocationManager()
    var userLocation: CLLocation?
    var heading: Double = 0
    var isAuthorized: Bool = false
    
    override init() {
        super.init()
        manager.delegate = self
        startLocationServices()
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            manager.startUpdatingLocation()
//            manager.startUpdatingHeading()
            isAuthorized = true
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.last
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        withAnimation{
            heading = newHeading.trueHeading
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
            manager.requestLocation()
        case .notDetermined:
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
            log.info("user location access denied")
        default:
            isAuthorized = true
            startLocationServices()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        log.error("\(error)")
    }
}
