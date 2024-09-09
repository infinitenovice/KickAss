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
            .foregroundColor(Color.theme.textPrimary)
            .font(.title)
            .tint(Color.theme.backgroundSecondary)
            .padding(.horizontal)
        }
    }
    func sparkleZoom() {
        withAnimation {
            var region = mapModel.region()
            region.span = GRID_CELL_ZOOM
            
            mapModel.camera = .region(region)
        }
    }
}

extension Color {
    public static var mapButton: Color {
        return Color(UIColor(red: 31/255, green: 40/255, blue: 41/255, alpha: 0.8))
    }
}


