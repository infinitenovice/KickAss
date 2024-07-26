//
//  SiteDetailView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI
import MapKit

struct SiteDetailView: View {
    let markerIndex: Int
    
    @Environment(SiteMarkerModel.self) var sites
    @Environment(MapModel.self) var map
    @Environment(NavigationModel.self) var navigation
    @State private var isShowingMessages = false

    var body: some View {
            HStack {
                VStack {
                    Group {
                        HStack {
                            Spacer()
                            Button {
                                sites.markers[markerIndex].latitude = map.region().center.latitude
                                sites.markers[markerIndex].longitude = map.region().center.longitude
                                map.selectedSparkleZoomLocation = map.region().center
                                } label: {Image(systemName: "move.3d")}
                            Spacer()
                            Button {
                                isShowingMessages = true
                                } label: {Image(systemName: "square.and.arrow.up")}
                            Spacer()
                            Button {
                                navigation.targetDestination = MKPlacemark(coordinate:  CLLocationCoordinate2D(latitude: sites.markers[markerIndex].latitude, longitude: sites.markers[markerIndex].longitude))                            } label: {Image(systemName: "car.circle")}
                            Spacer()
                        }//HStack
                        .buttonStyle(.borderedProminent)
                        .tint(.mapButton)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 300,height: 50)
                        switch sites.markers[markerIndex].type {
                        case .CheckInSite:
                            Text("Check In")
                        case .StartClueSite:
                            Text("Start Clue")
                        case .ClueSite:
                            StatusPickerView(markerIndex: markerIndex)
                            Button {
                                sites.markers[markerIndex].deleted = true
                            } label: {Text("Delete Marker")}
                                .buttonStyle(.borderedProminent)
                                .foregroundColor(.white)
                                .tint(.clear)
                        }
                    }//Group
                    Spacer()
                }//VStack
                .padding(.leading)
                Spacer()
            }//HStack
            .onDisappear() {sites.save()}
    }//body
}//View

#Preview {
    let map = MapModel()
    let sites = SiteMarkerModel()
    let navigation = NavigationModel()
    sites.newMarker(location: GridCenter)
    sites.selection = 0
    return SiteDetailView(markerIndex: 0)
        .environment(sites)
        .environment(map)
        .environment(navigation)
}
