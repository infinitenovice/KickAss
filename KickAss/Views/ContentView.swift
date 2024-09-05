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
    @Environment(StatisticsModel.self) var statisicsModel

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
//                    SiteDetailView(markerIndex: marker)
                    SiteEditView(markerIndex: marker)
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
            statisicsModel.update()
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


