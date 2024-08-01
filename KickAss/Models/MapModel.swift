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
    var camera: MapCameraPosition
    var markerSelection: Int?

    init() {
        camera = .region(GRID_REGION)
        self.markerSelection = nil
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
}
