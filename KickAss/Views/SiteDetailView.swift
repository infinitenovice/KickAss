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
    
    @Environment(SiteMarkerModel.self) var siteMarkerModel
    @Environment(MapModel.self) var mapModel
    @Environment(NavigationModel.self) var navigationModel
    @State private var isShowingMessages = false

    var body: some View {
            HStack {
                VStack {
                    Group {
                        HStack {
                            Spacer()
                            Button {
                                siteMarkerModel.markers[markerIndex].latitude = mapModel.region().center.latitude
                                siteMarkerModel.markers[markerIndex].longitude = mapModel.region().center.longitude
                                mapModel.selectedSparkleZoomLocation = mapModel.region().center
                                } label: {Image(systemName: "move.3d")}
                            Spacer()
                            Button {
                                isShowingMessages = true
                                } label: {Image(systemName: "square.and.arrow.up")}
                            Spacer()
                            Button {
                                navigationModel.targetDestination = MKPlacemark(coordinate:  CLLocationCoordinate2D(latitude: siteMarkerModel.markers[markerIndex].latitude, longitude: siteMarkerModel.markers[markerIndex].longitude))                            } label: {Image(systemName: "car.circle")}
                            Spacer()
                        }//HStack
                        .buttonStyle(.borderedProminent)
                        .tint(.mapButton)
                        .font(.title)
                        .foregroundColor(.white)
                        .frame(width: 300,height: 50)
                        switch siteMarkerModel.markers[markerIndex].type {
                        case .CheckInSite:
                            Text("Check In")
                        case .StartClueSite:
                            Text("Start Clue")
                        case .ClueSite:
                            StatusPickerView(markerIndex: markerIndex)
                            Button {
                                siteMarkerModel.markers[markerIndex].deleted = true
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
            .onDisappear() {siteMarkerModel.save()}
    }//body
}//View

#Preview {
    let mapModel = MapModel()
    let siteMarkerModel = SiteMarkerModel()
    let navigationModel = NavigationModel()
    siteMarkerModel.newMarker(location: GridCenter)
    siteMarkerModel.selection = 0
    return SiteDetailView(markerIndex: 0)
        .environment(siteMarkerModel)
        .environment(mapModel)
        .environment(navigationModel)
}
