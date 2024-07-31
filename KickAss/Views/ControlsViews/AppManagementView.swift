//
//  AppManagementView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct AppManagementView: View {
    @Environment (SiteMarkerModel.self) var siteMarkerModel
    @Environment (NavigationModel.self) var navigationModel
    @Environment (TimerModel.self) var timerModel
    @State var enableManagement: Bool = false


    var body: some View {
        @Bindable var navigationModel = navigationModel
        @Bindable var timerModel = timerModel
        @Bindable var siteMarkerModel = siteMarkerModel
        Form {
            Section(header: Text("Options/App Management")) {
                Toggle(isOn: $navigationModel.showTrackHistory) {
                    Text("Show Track History")
                }                
                Toggle(isOn: $siteMarkerModel.showRangeRadius) {
                    Text("Show Range Radius")
                }
                Toggle(isOn: $enableManagement) {
                    Text("Enable Management Functions")
                }

                if enableManagement {
                    DatePicker(selection: $timerModel.checkInTime, label: { Text("Check-In Time") })
                    DatePicker(selection: $timerModel.firstClueArrivalTime, label: { Text("First Clue Arrival Time") })
                    Button {
                        siteMarkerModel.deleteAllMarkers()
                    } label: {
                        Text("Delete Site Marker Data")
                    }
                    Button {
                        navigationModel.deleteTrackHistory()
                    } label: {
                        Text("Delete Track Data")
                    }
                    
                }
            }
        }
        .font(.title)
        .padding()
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    let navigationModel = NavigationModel()
    let timerModel = TimerModel()
    return AppManagementView()
        .environment(siteMarkerModel)
        .environment(navigationModel)
        .environment(timerModel)
}
