//
//  ControlsView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//


import SwiftUI
import MapKit

struct ControlsView: View {
    @Environment(MapModel.self) var map
    @Environment(CalliperModel.self) var callipers
    @Environment(HuntModel.self) var hunt
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
                                            if clearCount == 3 {
                                                callipers.clearMarkers()
                                            }
                                        } else {
                                            clearCount = 0
                                            callipers.newMarker(center: map.region().center, radius: radius)
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
                .sheet(isPresented: $settingsSheetShowing, onDismiss: {hunt.save()}) {
                    SettingsView()
                }
                
            }
        }
    }
}

#Preview {
    let hunt = HuntModel()
    let callipers = CalliperModel()
    let map = MapModel()
    return ControlsView()
            .environment(hunt)
        .environment(callipers)
        .environment(map)
}
