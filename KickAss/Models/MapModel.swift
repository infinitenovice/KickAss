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
    let maxZoom: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
    let gridCellZoom: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 1.25*GridCellHeightDegrees, longitudeDelta: 1.25*GridCellWidthDegrees)

    init() {
        camera = .region(GridRegion)
        self.markerSelection = nil
    }
    
    func region() -> MKCoordinateRegion {
        return camera.region ?? GridRegion
    }
    
    func gridZoom() {
        withAnimation {
            var region = self.region()
            if region.span.longitudeDelta == GridRegion.span.longitudeDelta {
                self.camera = .region(GridRegion)
            } else {
                region.span = GridRegion.span
                self.camera = .region(region)
            }
        }
    }
}
