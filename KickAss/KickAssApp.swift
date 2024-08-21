//
//  KickAssApp.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import SwiftUI

@main
struct KickAssApp: App {
    
    @State private var gridModel        = GridModel()
    @State private var markerModel  = MarkerModel()
    @State private var mapModel         = MapModel()
    @State private var calliperModel    = CalliperModel()
    @State private var locationManager  = LocationManager()
    @State private var navigationModel  = NavigationModel()
    @State private var huntInfoModel    = HuntInfoModel()
    @State private var timerModel       = TimerModel()

    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ContentView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(gridModel)
        .environment(markerModel)
        .environment(mapModel)
        .environment(calliperModel)
        .environment(locationManager)
        .environment(navigationModel)
        .environment(huntInfoModel)
        .environment(timerModel)
    }
}

