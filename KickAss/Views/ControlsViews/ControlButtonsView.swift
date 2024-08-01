//
//  ControlsView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//


import SwiftUI
import MapKit

struct ControlButtonsView: View {
    @Environment(MapModel.self) var mapModel
    @Environment(CalliperModel.self) var calliperModel
    @Environment(HuntInfoModel.self) var huntInfoModel
    @Environment(TimerModel.self) var timerModel
    @State private var input = ""
    @State private var iconColor = Color.black
    @State private var clearCount: Int = 0
    @State private var settingsSheetShowing: Bool = false
    
   
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                VStack {
                    
                    ZStack {
                        Image(systemName: "compass.drawing")
                            .font(.title)
                            .foregroundColor(iconColor)
                        TextField("", text: $input)
                            .tint(.black)
                            .font(.title2)
                            .frame(width:27)
                            .foregroundColor(.clear)
                            .onKeyPress { press in
                                iconColor = Color.blue
                                input += press.characters
                                if input[input.index(before: input.endIndex)] == "\r" {
                                    input = input.trimmingCharacters(in: .whitespacesAndNewlines)
                                    if let radius = Double(input) {
                                        if radius < 0.002 {
                                            clearCount += 1
                                            if clearCount == CALLIPER_CLEAR_CLICKS {
                                                calliperModel.clearMarkers()
                                            }
                                        } else {
                                            clearCount = 0
                                            calliperModel.newMarker(center: mapModel.region().center, radius: radius)
                                        }
                                    }
                                    input = ""
                                    iconColor = Color.black
                                }
                                return .handled
                            }
                    }
                    .padding()
                }
                Button {
                    settingsSheetShowing = true
                } label: {
                    Image(systemName: "gear")
                        .font(.title)
                        .foregroundColor(.black)
                }
                .sheet(isPresented: $settingsSheetShowing, onDismiss: {self.dismissActions()}) {
                    SettingsView()
                }
                
            }
        }
    }
    func dismissActions() {
        huntInfoModel.save()
        timerModel.setHuntStartTime(start: huntInfoModel.huntInfo.huntStartDate)
    }
}

#Preview {
    let timerModel = TimerModel()
    let huntInfoModel = HuntInfoModel()
    let calliperModel = CalliperModel()
    let mapModel = MapModel()
    return ControlButtonsView()
        .environment(huntInfoModel)
        .environment(calliperModel)
        .environment(mapModel)
        .environment(timerModel)
}
