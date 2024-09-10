//
//  NavigationModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import MapKit
import SwiftUI
import OSLog

@Observable
class NavigationModel_new {
    static let shared = NavigationModel_new()
    var log = Logger(subsystem: LOGSUBSYSTEM, category: "NavigationModel")
    
    var targetDestination: MKPlacemark?
    var destinationMonogram: String?
    var route: MKRoute?
//    var steps: [MKRoute.Step]
    var stepInstructions: String?
    var stepStartLocation: CLLocationCoordinate2D?
    var stepEndLocation: CLLocationCoordinate2D?
    var stepTotalDistance: CLLocationDistance?
    var stepRemainingDistance: CLLocationDistance?
    var trackingEnabled: Bool
    var trackHistoryPolyline: [CLLocationCoordinate2D]
    var trackHistoryData: [TrackPoint]
    var showTrackHistory: Bool

    let TRACKING_THREASHOLD = 4.0  //minimum number of meters between two location updates to register that the location changed
    let TRACK_BUFFER_SIZE = 15 //Number of location updates between json writes
    let MAX_TRACK_HISTORY = 20000
    
    init() {
        targetDestination = nil
        destinationMonogram = nil
        route = nil
//        steps = []
        stepInstructions = nil
        stepStartLocation = nil
        stepEndLocation = nil
        stepTotalDistance = nil
        stepRemainingDistance = nil
        trackingEnabled = true
        trackHistoryPolyline = []
        trackHistoryData = []
        showTrackHistory = false
        
        loadTrackHistory()
    }
    
    struct TrackPoint: Codable {
        var latitude: Double
        var longitude: Double
        var timestamp: Date
    }
    func setDestination(destination: MarkerModel.SiteMarker) {
        let coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        targetDestination = MKPlacemark(coordinate: coordinate)
        destinationMonogram = destination.monogram

    }
    func clearRoute() {
        targetDestination = nil
        destinationMonogram = nil
        route = nil
//        steps.removeAll()
        stepInstructions = nil
        stepStartLocation = nil
        stepEndLocation = nil
        stepTotalDistance = nil
        stepRemainingDistance = nil
    }
    func fetchRoute(locationManager: LocationManager) async {
        if let userLocation = locationManager.userLocation, let targetDestination = self.targetDestination {
            let request = MKDirections.Request()
            let startPlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let endPlacemark = MKPlacemark(coordinate: targetDestination.coordinate)
            let routeStart = MKMapItem(placemark: startPlacemark)
            let routeEnd = MKMapItem(placemark: endPlacemark)
            request.source = routeStart
            request.destination = routeEnd
            request.transportType = .automobile
            let directions = MKDirections(request: request)
            let result = try? await directions.calculate()
            route = result?.routes.first
//            steps = route!.steps
            nextStep()
        }
    }
    func navigationInProgress() -> Bool {
        return (route != nil)
    }
//    func routeRegion() -> MKCoordinateRegion? {
//        
//        if navigationInProgress() {
//            var maxLat = -90.0
//            var minLat = 90.0
//            var maxLon = -180.0
//            var minLon = 180.0
//            
//            for stepIndex in 0..<steps.count {
//                let coordinates = steps[stepIndex].polyline.coordinates
//                for pointIndex in 0..<coordinates.count {
//                    let point = coordinates[pointIndex]
//                    if point.latitude > maxLat {maxLat = point.latitude}
//                    if point.latitude < minLat {minLat = point.latitude}
//                    if point.longitude > maxLon {maxLon = point.longitude}
//                    if point.longitude < minLon {minLon = point.longitude}
//                }
//            }
//            var region: MKCoordinateRegion = GRID_REGION
//
//            region.span = MKCoordinateSpan(latitudeDelta: (maxLat-minLat)*1.1, longitudeDelta: (maxLon-minLon)*1.1)
//            region.center = CLLocationCoordinate2D(latitude: (maxLat-minLat)/2+minLat, longitude: (maxLon-minLon)/2+minLon)
//            log.info(region.center)
//            return region
//        } else {
//            return nil
//        }
//    }
    func nextStep() {
        if let steps = route?.steps {
            if !steps.isEmpty {
                let coordinates = steps[0].polyline.coordinates
                stepStartLocation = coordinates.first
                stepEndLocation = coordinates.last
                stepInstructions = steps[0].instructions
            } else {
                stepStartLocation = stepEndLocation
                stepEndLocation = targetDestination?.coordinate
                stepInstructions = "Proceed on foot"
            }
            stepTotalDistance = stepStartLocation?.distance(from: stepEndLocation!)
        }
    }
    func updateNavigation(oldCoord: CLLocationCoordinate2D, newCoord: CLLocationCoordinate2D) {
        if let startLocation = stepStartLocation, let stepTotalDistance = stepTotalDistance {
            let distanceTraveled = startLocation.distance(from: newCoord)
            let remainingDistance = stepTotalDistance - distanceTraveled
            stepRemainingDistance = remainingDistance
            if remainingDistance <= 0 {
                nextStep()
            }
        }
    }
    func updateTrackHistory(oldLocation: CLLocation, newLocation: CLLocation) {
            if newLocation.distance(from: oldLocation) > TRACKING_THREASHOLD && trackingEnabled {
            if trackHistoryData.count >= MAX_TRACK_HISTORY {
                trackHistoryPolyline.removeSubrange(0...100)
                trackHistoryData.removeSubrange(0...100)
            }
            trackHistoryPolyline.append(newLocation.coordinate)
            trackHistoryData.append(TrackPoint(latitude: newLocation.coordinate.latitude, longitude: newLocation.coordinate.longitude, timestamp: newLocation.timestamp))
            if trackHistoryData.count%TRACK_BUFFER_SIZE == 0 {
                saveTrackHistory()
            }
        }
    }
    func updateLocation(oldLocation: CLLocation?, newLocation: CLLocation?) {
            if navigationInProgress() {
                if let oldCoord = oldLocation?.coordinate, let newCoord = newLocation?.coordinate {
                    updateNavigation(oldCoord: oldCoord, newCoord: newCoord)
                }
            }
            if trackingEnabled {
                if let oldLocation = oldLocation, let newLocation = newLocation {
                    updateTrackHistory(oldLocation: oldLocation, newLocation: newLocation)
                }
            }
    }
    func loadTrackHistory() {
        if FileManager().fileExists(atPath: TRACK_HISTORY_URL.path) {
            do {
                let jsonData = try Data(contentsOf: TRACK_HISTORY_URL)
                let data = try JSONDecoder().decode([TrackPoint].self, from: jsonData)
                trackHistoryData = data
                log.info("Loaded Track History: \(self.trackHistoryData.count)")
                for trackIndex in 0..<trackHistoryData.count {
                    let point = CLLocationCoordinate2D(latitude: trackHistoryData[trackIndex].latitude, longitude: trackHistoryData[trackIndex].longitude)
                    trackHistoryPolyline.append(point)
                }
            } catch {
                log.error("\(error)")
            }
        }
    }
    func saveTrackHistory() {
        do {
            let data = try JSONEncoder().encode(trackHistoryData)
            try data.write(to: TRACK_HISTORY_URL)
        } catch {
            log.error("\(error)")
        }
    }
    func deleteTrackHistory() {
        trackHistoryData.removeAll()
        trackHistoryPolyline.removeAll()
        do {
            try FileManager.default.removeItem(at: TRACK_HISTORY_URL)
        } catch {
            log.error("\(error)")
        }
    }
}


