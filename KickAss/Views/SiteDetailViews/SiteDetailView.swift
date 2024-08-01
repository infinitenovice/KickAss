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
    @Environment(HuntInfoModel.self) var huntInfoModel
    @Environment(TimerModel.self) var timerModel
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
                                } label: {Image(systemName: "move.3d")}
                            Spacer()
                            Button {
                                isShowingMessages = true
                                } label: {Image(systemName: "square.and.arrow.up")}
                                .sheet(isPresented: self.$isShowingMessages) {
                                    MessageSender(recipients: huntInfoModel.phoneList(),
                                                  message: "http://maps.apple.com/?ll="+String(siteMarkerModel.markers[markerIndex].latitude)+","+String(siteMarkerModel.markers[markerIndex].longitude))
                                }

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
                            CheckInView()
                        case .StartClueSite:
                            StartingClueView(markerIndex: markerIndex)
                        case .PossibleClueSite:
                            PossibleClueView(markerIndex: markerIndex)
                        case .FoundClueSite:
                            FoundClueView(markerIndex: markerIndex)
                        case .JackassSite:
                            JackAssSiteView(markerIndex: markerIndex)
                        }
                    }//Group
                    Spacer()
                }//VStack
                .padding(.leading)
                Spacer()
            }//HStack
            .onDisappear() {
                siteMarkerModel.save()
//                timerModel.resetClueTimer()
            }
    }//body
}//View

#Preview {
    let timerModel = TimerModel()
    let huntInfoModel = HuntInfoModel()
    let mapModel = MapModel()
    let siteMarkerModel = SiteMarkerModel()
    let navigationModel = NavigationModel()
    siteMarkerModel.newMarker(location: GRID_CENTER)
    siteMarkerModel.selection = 0
    return SiteDetailView(markerIndex: 0)
        .environment(siteMarkerModel)
        .environment(mapModel)
        .environment(navigationModel)
        .environment(huntInfoModel)
        .environment(timerModel)
}
