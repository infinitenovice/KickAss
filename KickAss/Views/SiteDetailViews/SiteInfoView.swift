//
//  SiteContentView.swift
//  KickAss
//
//  Created by Infinite Novice on 9/4/24.
//

import SwiftUI

struct SiteInfoView: View {
    let markerIndex: Int

    @Environment(MarkerModel.self) var markerModel
    @Environment(TimerModel.self) var timerModel
    
    @State var pickerShowing: Bool = false
    @State var longPressMenuShowing: Bool = false
    

    var body: some View {
        @Bindable var markerModel = markerModel
        
        ZStack{
            RoundedRectangle(cornerRadius: 15)
                .fill(.backgroundSecondary)
            HStack{
                VStack(alignment: .leading) {
                    HStack{
                        TextField(text: $markerModel.data.markers[markerIndex].title) {
                            Text("Clue Site")
                        }
                        .font(.system(size: 22, weight: .bold))
                        .frame(width: 140)
                        Spacer()
                        Group {
                            ZStack {
                                Circle()
                                    .fill(.backgroundSecondary)
                                    .stroke(.textSecondary, lineWidth: 2)
                                Text(markerModel.data.markers[markerIndex].monogram)
                            }
                            .font(.system(size: 22, weight: .bold))
                            .foregroundStyle(.textPrimary)
                            .frame(width: 45, height: 45)
                            .onTapGesture {
                                if markerModel.data.markers[markerIndex].type != .CheckInSite && markerModel.data.markers[markerIndex].type != .JackassSite {
                                    pickerShowing.toggle()
                                }
                            }
                            .onLongPressGesture{
                                if markerModel.data.markers[markerIndex].type != .CheckInSite &&
                                    markerModel.data.markers[markerIndex].type != .StartClueSite {
                                        longPressMenuShowing = true
                                }
                            }
                        }
                        .popover(isPresented: $pickerShowing) {
                            SitePickerView(markerIndex: markerIndex, pickedItem: $markerModel.data.markers[markerIndex].monogram, isShowing: $pickerShowing)
                        }
                        .popover(isPresented: $longPressMenuShowing) {
                            LongPressMenuView(markerIndex: markerIndex, isShowing: $longPressMenuShowing)
                        }
                    }
                    LatLonDisplayView(markerIndex: markerIndex)
                        .foregroundColor(.textSecondary)
                    Spacer()
                    switch markerModel.data.markers[markerIndex].type {
                    case .CheckInSite:
                        Toggle("Check in", isOn: $markerModel.data.markers[markerIndex].found)
                            .toggleStyle(.checkboxIOS)
                            .onChange(of: markerModel.data.markers[markerIndex].found) {_, checkedIn in
                                if checkedIn {
                                    timerModel.checkIn()
                                    markerModel.selection = nil
                                } else {
                                    timerModel.checkInTime = .distantFuture
                                }
                            }
                    case .StartClueSite:
                        if markerModel.data.markers[markerIndex].monogram != "?" {
                            Toggle("Found", isOn: $markerModel.data.markers[markerIndex].found)
                                .toggleStyle(.checkboxIOS)
                                .onChange(of: markerModel.data.markers[markerIndex].found) {_, found in
                                    if found {
                                        markerModel.markStartingClue()
                                        timerModel.setFirstClueArrivalTime()
                                    } else {
                                        timerModel.firstClueArrivalTime = .distantFuture
                                        timerModel.clueStartTime = timerModel.huntStartTime
                                    }
                                }
                        } else {
                            Text("No Clue Letter")
                                .foregroundStyle(.textStandout)
                        }
                    case .ClueSite:
                        if markerModel.data.markers[markerIndex].monogram != "?" {
                            Toggle("Found", isOn: $markerModel.data.markers[markerIndex].found)
                                .toggleStyle(.checkboxIOS)
                                .padding(.bottom,4)
                                .onChange(of: markerModel.data.markers[markerIndex].found) {_, found in
                                    if found {
                                        timerModel.resetClueTimer()
                                    }
                                }
                            Toggle("Emergency", isOn: $markerModel.data.markers[markerIndex].emergency)
                                .toggleStyle(.checkboxIOS)
                        } else {
                            Text("No Clue Letter")
                                .foregroundStyle(.textStandout)
                        }
                    case .JackassSite:
                        HStack {
                            Spacer()
                            Image("KickingDonkey")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .background(.backgroundSecondary)
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .font(.system(size: 20))
                .padding()
            }
        }
    }
}





