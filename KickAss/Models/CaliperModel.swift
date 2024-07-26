//
//  CaliperModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import CoreLocation

@Observable
class CalliperModel {
    var markers: [CalliperMarker] = []
    
    struct CalliperMarker: Identifiable {
        var id: Int = 0
        var center: CLLocationCoordinate2D = GridCenter
        var radius: Double = 0.0
    }
    func newMarker(center: CLLocationCoordinate2D, radius: Double) {
        let marker: CalliperMarker = CalliperMarker(id: markers.count, center: center, radius: radius * MapInchToMeters)
        markers.append(marker)
    }
    func clearMarkers() {
        markers.removeAll()
    }
}

