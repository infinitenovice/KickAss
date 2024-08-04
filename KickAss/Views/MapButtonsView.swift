//
//  MapButtonsView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI
import MapKit

struct MapButtonsView: View {
    @Environment(MapModel.self) var mapModel
    @Environment(MarkerModel.self) var markerModel
    @Environment(NavigationModel.self) var navigationModel

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    mapModel.gridZoom()
                    } label: {Image(systemName: "map")}
                Button {
                    sparkleZoom()
                    } label: {Image(systemName: "sparkle.magnifyingglass")}
                Button {
                    markerModel.newMarker(location: mapModel.region().center)
                    } label: {Image(systemName: "mappin.circle")}
                Spacer()
            }//VStack
            .buttonStyle(.borderedProminent)
            .foregroundColor(.white)
            .font(.title)
            .tint(.mapButton)
            .padding(.horizontal)
        }
    }
    func sparkleZoom() {
        withAnimation {
            var region = mapModel.region()
            region.span = GRID_CELL_ZOOM
            
            if let routeRegion = navigationModel.routeRegion() {
                region = routeRegion
            } else {
                if let selection = markerModel.selection {
                    if markerModel.validMarker(markerIndex: selection) {
                        region.center = CLLocationCoordinate2D(latitude: markerModel.data.markers[selection].latitude, longitude: markerModel.data.markers[selection].longitude)
                        if markerModel.data.markers[selection].type == .FoundClueSite || (markerModel.data.markers[selection].type == .StartClueSite && markerModel.data.startingClueSet) {
                            region.span = SEARCH_ZOOM_REGION
                        }
                    }
                }
            }
            mapModel.camera = .region(region)
        }
    }
}

extension Color {
    public static var mapButton: Color {
        return Color(UIColor(red: 31/255, green: 40/255, blue: 41/255, alpha: 0.8))
    }
}


#Preview {
    let navigationModel = NavigationModel()
    let markerModel = MarkerModel()
    let mapModel = MapModel()
    return MapButtonsView()
        .environment(markerModel)
        .environment(mapModel)
        .environment(navigationModel)
}
