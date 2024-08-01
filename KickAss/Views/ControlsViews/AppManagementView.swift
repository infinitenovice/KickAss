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
    @Environment (HuntInfoModel.self) var huntInfoModel
    @State var enableManagement: Bool = false
    @State var enableReset: Bool = false


    var body: some View {
        @Bindable var navigationModel = navigationModel
        @Bindable var timerModel = timerModel
        @Bindable var siteMarkerModel = siteMarkerModel
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
                Toggle(isOn: $siteMarkerModel.showRangeRadius) {
                    Text("Show Range Radius")
                }
                if siteMarkerModel.showRangeRadius {
                    Stepper(value: $siteMarkerModel.rangeRadius, in: 3...5, step: 0.1) {
                        Text(String(format: "Range Radius %0.1f", siteMarkerModel.rangeRadius))
                    }
                }
                Toggle(isOn: $enableManagement) {
                    Text("Enable Management Functions")
                }
                if enableManagement {
                    DatePicker(selection: $timerModel.checkInTime, label: { Text("Check-In Time") })
                    DatePicker(selection: $timerModel.firstClueArrivalTime, label: { Text("First Clue Arrival Time") })
                    Toggle(isOn: $enableReset) {
                        Text("Enable Hunt Reset")
                    }
                    if enableReset {
                        HStack {
                            Text("Reset Hunt - CANNOT BE UNDONE!")
                            Spacer()
                            Button {
                                siteMarkerModel.deleteAllMarkers()
                                navigationModel.deleteTrackHistory()
                                timerModel.checkInTime = .distantFuture
                                timerModel.firstClueArrivalTime = .distantFuture
                                siteMarkerModel.startingClueSet = false
                            } label: {
                                Text("Reset")
                            }
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

#Preview {
    let huntInfoModel = HuntInfoModel()
    let siteMarkerModel = SiteMarkerModel()
    let navigationModel = NavigationModel()
    let timerModel = TimerModel()
    return AppManagementView()
        .environment(siteMarkerModel)
        .environment(navigationModel)
        .environment(timerModel)
        .environment(huntInfoModel)
}
