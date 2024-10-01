//
//  MapModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import MapKit
import SwiftUI

@Observable
class MapModel {
    static let shared = MapModel()

    var camera: MapCameraPosition

    private init() {
        camera = .region(GRID_REGION)
    }
    
    func region() -> MKCoordinateRegion {
        return camera.region ?? GRID_REGION
    }
    
    func gridZoom() {
        withAnimation {
            var region = self.region()
            if region.span.longitudeDelta == GRID_REGION.span.longitudeDelta {
                self.camera = .region(GRID_REGION)
            } else {
                region.span = GRID_REGION.span
                self.camera = .region(region)
            }
        }
    }
    
    func radiusZoom(center: CLLocationCoordinate2D, radiusMeters: Double) {
        withAnimation {
            let padding = 1.1
            var region = self.region()
            region.span.longitudeDelta = radiusMeters * 2 * padding * DEGREES_PER_METER_LON
            region.span.latitudeDelta = radiusMeters * 2 * padding * DEGRESS_PER_METER_LAT
            region.center = center
            self.camera = .region(region)
        }
    }
}
