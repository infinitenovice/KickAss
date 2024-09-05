//
//  LatLonDisplayView.swift
//  KickAss
//
//  Created by Infinite Novice on 8/8/24.
//

import SwiftUI
import MapKit
import AVFoundation


struct LatLonDisplayView: View {
    let markerIndex: Int

    @Environment(MarkerModel.self) var markerModel
    @Environment(GridModel.self) var gridModel

    var body: some View {
        @Bindable var markerModel = markerModel
        
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 5
            return formatter
        }()

        HStack {
            TextField("", value: $markerModel.data.markers[markerIndex].latitude, formatter: formatter)
            TextField("", value: $markerModel.data.markers[markerIndex].longitude, formatter: formatter)
        }
        .onDisappear() {
            let point = CLLocationCoordinate2D(latitude: markerModel.data.markers[markerIndex].latitude, longitude: markerModel.data.markers[markerIndex].longitude)
            if !gridModel.onGrid(point: point) && markerModel.data.markers[markerIndex].type != .CheckInSite {
                markerModel.selection = markerIndex
                AudioServicesPlaySystemSound(SystemSoundID(BUTTON_ERROR_SOUND))
            }
        }
    }
}

