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
    @Environment(SiteMarkerModel.self) var siteMarkerModel
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
                    siteMarkerModel.newMarker(location: mapModel.region().center)
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
                if let selection = siteMarkerModel.selection {
                    if siteMarkerModel.validMarker(markerIndex: selection) {
                        region.center = CLLocationCoordinate2D(latitude: siteMarkerModel.markers[selection].latitude, longitude: siteMarkerModel.markers[selection].longitude)
                        if siteMarkerModel.markers[selection].type == .FoundClueSite {
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
    let siteMarkerModel = SiteMarkerModel()
    let mapModel = MapModel()
    return MapButtonsView()
        .environment(siteMarkerModel)
        .environment(mapModel)
        .environment(navigationModel)
}
