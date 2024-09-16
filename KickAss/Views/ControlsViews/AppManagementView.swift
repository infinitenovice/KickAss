//
//  AppManagementView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct AppManagementView: View {
    @Environment (MarkerModel.self) var markerModel
    @Environment (NavigationModel.self) var navigationModel
    @Environment (TimerModel.self) var timerModel
    @Environment (HuntInfoModel.self) var huntInfoModel
    @Environment (NavLinkModel.self) var navLinkModel
    
    @State var enableManagement: Bool = false


    var body: some View {
        @Bindable var navigationModel = navigationModel
        @Bindable var timerModel = timerModel
        @Bindable var markerModel = markerModel
        @Bindable var huntInfoModel = huntInfoModel
        Form {
            Section(header: Text("Options/App Management")) {
                Toggle(isOn: $huntInfoModel.huntInfo.smsFowardingEnabled) {
                    Text("Enable SMS Forwarding")
                        .font(.title3)
                }
                Toggle(isOn: $navigationModel.showTrackHistory) {
                    Text("Show Track History")
                }                
                Toggle(isOn: $markerModel.showRangeRadius) {
                    Text("Show Range Radius")
                }
                if markerModel.showRangeRadius {
                    Stepper(value: $markerModel.rangeRadius, in: 3...5, step: 0.1) {
                        Text(String(format: "Update Range Radius (miles)   %0.1f", markerModel.rangeRadius))
                    }
                }
                Text("")
                Toggle(isOn: $enableManagement) {
                    Text("Enable Management Functions")
                }
                if enableManagement {
                    DatePicker(selection: $timerModel.checkInTime, label: { Text("Edit Check-In Time") })
                    DatePicker(selection: $timerModel.firstClueArrivalTime, label: { Text("Edit First Clue Arrival Time") })
                    Text("")
                    HStack {
                        Text("Reset Hunt - CANNOT BE UNDONE!")
                        Spacer()
                        Button {
                            markerModel.deleteAllMarkers()
                            navigationModel.deleteTrackHistory()
                            timerModel.checkInTime = .distantFuture
                            timerModel.firstClueArrivalTime = .distantFuture
                        } label: {
                            Text("Reset")
                        }
                    }
                }
            }
        }
        .font(.title2)
        .padding()
        .buttonStyle(.borderedProminent)
    }
}

