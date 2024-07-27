//
//  ContentView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @Environment(MapModel.self) var mapModel
    @Environment(SiteMarkerModel.self) var siteMarkerModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(LocationManager.self) var locationManager
    @Environment(TimerModel.self) var timerModel
    @Environment(HuntInfoModel.self) var huntInfoModel

    var body: some View {
        ZStack {
            MapView()
            MapButtonsView()
            CrossHairView()
            ControlsView()
            HuntStatusView()
            if navigationModel.navigationInProgress() {
                NavigationView()
            }
            if let selectedMarker = siteMarkerModel.selection {
                SiteDetailView(markerIndex: selectedMarker)
            }
        }
        .onAppear() {
            siteMarkerModel.load()
            timerModel.setHuntStartTime(start: huntInfoModel.huntInfo.huntStartDate)
        }
        .onChange(of: siteMarkerModel.selection) {
            mapModel.setSparkleZoom(location: siteMarkerModel.selectedMarkerCoordinates())
        }
        .task(id: navigationModel.targetDestination) {
            await navigationModel.fetchRoute(locationManager: locationManager)
        }
        .onReceive(timerModel.timer) { _ in
            timerModel.updateTimers()
        }
    }
}

#Preview {
    let timerModel = TimerModel()
    let huntInfoModel = HuntInfoModel()
    let gridModel = GridModel()
    let mapModel = MapModel()
    let siteMarkerModel = SiteMarkerModel()
    let calliperModel = CalliperModel()
    let navigationModel = NavigationModel()
    let locationManager = LocationManager()
    return ContentView()
        .environment(huntInfoModel)
        .environment(gridModel)
        .environment(mapModel)
        .environment(siteMarkerModel)
        .environment(calliperModel)
        .environment(navigationModel)
        .environment(locationManager)
        .environment(timerModel)

}
