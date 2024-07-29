//
//  NavigationModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import MapKit
import SwiftUI

@Observable
class NavigationModel {
    var targetDestination: MKPlacemark?
    var route: MKRoute?
    var steps: [MKRoute.Step]
    var stepInstructions: String?
    var stepStartLocation: CLLocationCoordinate2D?
    var stepEndLocation: CLLocationCoordinate2D?
    var stepTotalDistance: CLLocationDistance?
    var stepRemainingDistance: CLLocationDistance?
    var trackHistory: [CLLocationCoordinate2D]

    init() {
        targetDestination = nil
        route = nil
        steps = []
        stepInstructions = nil
        stepStartLocation = nil
        stepEndLocation = nil
        stepTotalDistance = nil
        stepRemainingDistance = nil
        trackHistory = []
    }
    func clearRoute() {
        targetDestination = nil
        route = nil
        steps.removeAll()
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
            steps = route!.steps
            nextStep()
        }
    }
    func navigationInProgress() -> Bool {
        return (route != nil)
    }
    func routeRegion() -> MKCoordinateRegion? {
        
        if navigationInProgress() {
            var maxLat = -90.0
            var minLat = 90.0
            var maxLon = -180.0
            var minLon = 180.0
            
            for stepIndex in 0..<steps.count {
                let coordinates = steps[stepIndex].polyline.coordinates
                for pointIndex in 0..<coordinates.count {
                    let point = coordinates[pointIndex]
                    if point.latitude > maxLat {maxLat = point.latitude}
                    if point.latitude < minLat {minLat = point.latitude}
                    if point.longitude > maxLon {maxLon = point.longitude}
                    if point.longitude < minLon {minLon = point.longitude}
                }
            }
            var region: MKCoordinateRegion = GridRegion

            region.span = MKCoordinateSpan(latitudeDelta: (maxLat-minLat)*1.2, longitudeDelta: (maxLon-minLon)*1.2)
            region.center = CLLocationCoordinate2D(latitude: (maxLat-minLat)/2+minLat, longitude: (maxLon-minLon)/2+minLon)
            print(region.center)
            return region
        } else {
            return nil
        }
    }
    func nextStep() {
        if !steps.isEmpty {
            steps.remove(at: 0)
        }
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
        stepRemainingDistance = stepTotalDistance
    }
    func updateStepRemainingDistance(locationManager: LocationManager) {
        if stepEndLocation != nil {
            let distanceTraveled = locationManager.userLocation?.coordinate.distance(from: stepStartLocation!)
            stepRemainingDistance = stepTotalDistance! - distanceTraveled!
            if stepTotalDistance! <= 0 {
                nextStep()
            }
        }
    }
    func updateTrackHistory(oldLocation: CLLocation?, newLocation: CLLocation?) {
        if let oldLocation = oldLocation, let newLocation = newLocation {
            if newLocation.distance(from: oldLocation) > 4 {
                trackHistory.append(newLocation.coordinate)
            }
        }
    }
    
}
public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
public extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}

