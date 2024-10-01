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
class NavigationModel {
    static let shared = NavigationModel()
    var markerModel = MarkerModel.shared
    var mapModel = MapModel.shared
    
    var log = Logger(subsystem: LOGSUBSYSTEM, category: "NavigationModel")
    
    var targetDestination: MKPlacemark? = nil
    var destinationIndex: Int? = nil
    var route: MKRoute? = nil
    var wayPointNext: CLLocationCoordinate2D? = nil
    var destinationMonogram: String = ""
    var stepInstructions: String = ""
    var estimatedArrivalTime: Date = .distantFuture
    var wayPointPrevious: CLLocationCoordinate2D? = nil
    var steps: [MKRoute.Step] = []
    
    var trackingEnabled: Bool = true
    var showTrackHistory: Bool = false
    var trackHistoryPolyline: [CLLocationCoordinate2D] = []
    var trackHistoryData: [TrackPoint] = []

    let TRACKING_THREASHOLD = 4.0  //minimum number of meters between two location updates to register that the location changed
    let TRACK_BUFFER_SIZE = 15 //Number of location updates between json writes
    let MAX_TRACK_HISTORY = 20000
    
    init() {
        loadTrackHistory()
    }
    
    struct TrackPoint: Codable {
        var latitude: Double
        var longitude: Double
        var timestamp: Date
    }
    func navigationInProgress() -> Bool {
        return (route != nil)
    }
    func updateLocation(oldLocation: CLLocation?, newLocation: CLLocation?) {
        if let oldLocation = oldLocation, let newLocation = newLocation {
            if route != nil {
                updateRouteProgress(currentLocation: newLocation.coordinate)
            }
            if trackingEnabled {
                updateTrackHistory(oldLocation: oldLocation, newLocation: newLocation)
            }
        }
    }
    func initiateRoute(markerIndex: Int) {
        destinationIndex = markerIndex
        let destination = markerModel.data.markers[markerIndex]
        let coordinate = CLLocationCoordinate2D(latitude: destination.latitude, longitude: destination.longitude)
        targetDestination = MKPlacemark(coordinate: coordinate)
        destinationMonogram = destination.monogram
    }
    func clearRoute() {
        targetDestination = nil
        destinationIndex = nil
        route = nil
        destinationMonogram = ""
        stepInstructions = ""
        wayPointPrevious = nil
        wayPointNext = nil
        estimatedArrivalTime = .distantFuture
        steps = []
    }
    func fetchRoute(locationManager: LocationManager) async {
        if let userLocation = locationManager.userLocation, let targetDestination = self.targetDestination {
            log.info("Fetch Route")
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
            if let route = route {
                estimatedArrivalTime = Date.now.addingTimeInterval(route.expectedTravelTime)
                steps = route.steps
                var rect = route.polyline.boundingMapRect
                mapModel.camera = .rect(route.polyline.boundingMapRect)
                nextStep()
            } else {
                log.error("fetchRoute failed")
            }
        }
    }
    func nextStep() {
        if !steps.isEmpty {
            steps.remove(at: 0)
        }
        if !steps.isEmpty {
            let coordinates = steps[0].polyline.coordinates
            wayPointPrevious = coordinates.first
            wayPointNext = coordinates.last
            stepInstructions = steps[0].instructions
        } else {
            wayPointPrevious = wayPointNext
            wayPointNext = targetDestination?.coordinate
            stepInstructions = "Proceed on foot"
        }
    }
    func updateRouteProgress(currentLocation: CLLocationCoordinate2D) {
        if let wayPointPrevious = wayPointPrevious, let wayPointNext = wayPointNext {
            let totalDistance = wayPointPrevious.distance(from: wayPointNext)
            let distanceTraveled = wayPointPrevious.distance(from: currentLocation)
            let remainingDistance = totalDistance - distanceTraveled
            if remainingDistance <= 20 {
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

