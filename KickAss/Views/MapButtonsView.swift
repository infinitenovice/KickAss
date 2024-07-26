//
//  MapButtonsView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct MapButtonsView: View {
    @Environment(MapModel.self) var map
    @Environment(SiteMarkerModel.self) var sites

    var body: some View {
        HStack {
            Spacer()
            VStack {
                Button {
                    map.gridZoom()
                    } label: {Image(systemName: "map")}
                Button {
                    map.sparkleZoom()
                    } label: {Image(systemName: "sparkle.magnifyingglass")}
                Button {
                    sites.newMarker(location: map.region().center)
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
}

extension Color {
    public static var mapButton: Color {
        return Color(UIColor(red: 31/255, green: 40/255, blue: 41/255, alpha: 0.8))
    }
}


#Preview {
    let sites = SiteMarkerModel()
    let map = MapModel()
    return MapButtonsView()
        .environment(sites)
        .environment(map)
}
