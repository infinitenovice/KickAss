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
    @Environment(MarkerModel.self) var markerModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(LocationManager.self) var locationManager
    @Environment(TimerModel.self) var timerModel
    @Environment(HuntInfoModel.self) var huntInfoModel
    @Environment(CloudKitModel.self) var cloudKitModel

    var body: some View {
        ZStack {
            MapView()
            MapButtonsView()
            CrossHairView()
            ControlButtonsView()
            StatusBarView()
            if navigationModel.navigationInProgress() {
                NavigationView()
            }
            if let marker = markerModel.selection {
                if markerModel.validMarker(markerIndex: marker){
                    SiteDetailView(markerIndex: marker)
                }
            }
        }
        .onAppear() {
            markerModel.load()
            timerModel.setHuntStartTime(start: huntInfoModel.huntInfo.huntStartDate)
        }
        .task(id: navigationModel.targetDestination) {
            await navigationModel.fetchRoute(locationManager: locationManager)
        }
        .onReceive(timerModel.timer) { _ in
            timerModel.updateTimers()
        }
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            navigationModel.updateLocation(oldLocation: oldValue, newLocation: newValue)
        }
        .onChange(of: timerModel.huntState) { oldValue, newValue in
            if newValue == TimerModel.HuntState.InProgress {
                navigationModel.trackingEnabled = true
                timerModel.resetClueTimer()
                if !markerModel.data.startingClueSet {
                    markerModel.selection = 1 //Starting Clue Site
                }
            } else {
                navigationModel.trackingEnabled = false
                timerModel.stopClueTimer()
            }
        }
        .onOpenURL() { url in
            markerModel.processIncommingMarker(url: url)
        }
    }
}

#Preview {
    let timerModel = TimerModel()
    let huntInfoModel = HuntInfoModel()
    let gridModel = GridModel()
    let mapModel = MapModel()
    let markerModel = MarkerModel()
    let calliperModel = CalliperModel()
    let navigationModel = NavigationModel()
    let locationManager = LocationManager()
    let cloudKitModel = CloudKitModel()
    return ContentView()
        .environment(huntInfoModel)
        .environment(gridModel)
        .environment(mapModel)
        .environment(markerModel)
        .environment(calliperModel)
        .environment(navigationModel)
        .environment(locationManager)
        .environment(timerModel)
        .environment(cloudKitModel)

}
