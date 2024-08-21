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
            Spacer()
            TextField("", value: $markerModel.data.markers[markerIndex].latitude, formatter: formatter)
                .font(.title3)
                .frame(width: 110)
            TextField("", value: $markerModel.data.markers[markerIndex].longitude, formatter: formatter)
                .font(.title3)
                .frame(width: 110)
            Spacer()
        }
        .frame(width: 300)
        .onDisappear() {
            let point = CLLocationCoordinate2D(latitude: markerModel.data.markers[markerIndex].latitude, longitude: markerModel.data.markers[markerIndex].longitude)
            if !gridModel.onGrid(point: point) {
                markerModel.selection = markerIndex
                AudioServicesPlaySystemSound(SystemSoundID(BUTTON_ERROR_SOUND))
            }
        }
    }
}

#Preview {
    let gridModel = GridModel()
    let markerModel = MarkerModel()
    markerModel.newMarker(location: GRID_CENTER)
    markerModel.selection = 0
    return LatLonDisplayView(markerIndex: 0)
        .environment(markerModel)
        .environment(gridModel)
}
