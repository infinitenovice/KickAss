//
//  KickAssApp.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

/*
 Todo:
 Long press option
 Update timer and stats display
 font extensions
 checkbox color switching
 

 Add searching for message and monogram to nav link app
 Add found button to nav link app
 Publish nav link to test flight
 Add auto-drop to navlink app instead of post/airdrop shortcut
 
 Check route functionality, remove my step processing if possible
 Refactor environment with container class
 Refactor globals to config class
 clue letter filter on picker so letter can be used only once
 Refactor to not have to pass marker selection as parameter
 Refactor persistent data into top level class
 */
import SwiftUI

@main
struct KickAssApp: App {
    
    @State private var gridModel        = GridModel()
    @State private var mapModel         = MapModel()
    @State private var calliperModel    = CalliperModel()
    @State private var locationManager  = LocationManager()
    @State private var navigationModel  = NavigationModel()
    @State private var huntInfoModel    = HuntInfoModel()
    @State private var cloudKitModel    = CloudKitModel()
    @State private var statisticsModel  = StatisticsModel()
    @State private var timerModel       = TimerModel.shared
    @State private var markerModel      = MarkerModel.shared

    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ContentView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(gridModel)
        .environment(mapModel)
        .environment(calliperModel)
        .environment(locationManager)
        .environment(navigationModel)
        .environment(huntInfoModel)
        .environment(cloudKitModel)
        .environment(statisticsModel)
        .environment(timerModel)
        .environment(markerModel)
    }
}

