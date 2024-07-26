//
//  KickAssApp.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import SwiftUI

@main
struct KickAssApp: App {
    @State private var grid = GridModel()
    @State private var sites = SiteMarkerModel()
    @State private var map = MapModel()
    @State private var callipers = CalliperModel()
    @State private var locationManager = LocationManager()
    @State private var navigation = NavigationModel()
    @State private var hunt = HuntModel()

    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                MapView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(grid)
        .environment(sites)
        .environment(map)
        .environment(callipers)
        .environment(locationManager)
        .environment(navigation)
        .environment(hunt)
    }
}
