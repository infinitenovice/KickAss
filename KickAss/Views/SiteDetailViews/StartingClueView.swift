//
//  StartingClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//
//
//import SwiftUI
//import AVFoundation
//
//struct StartingClueView: View {
//    let markerIndex: Int
//
//    @Environment(MarkerModel.self) var markerModel
//    @Environment(TimerModel.self) var timerModel
//
//    var body: some View {
//        @Bindable var markerModel = markerModel
//
//        VStack{
//            List {
//                Text("Starting Clue Site")
//                if timerModel.firstClueArrivalTime < .now {
//                    Text("Clue \(markerModel.data.markers[markerIndex].monogram)")
//                } else {
//                    Picker("Clue Letter", selection: $markerModel.data.markers[markerIndex].monogram) {
//                        ForEach(markerModel.ClueLetterMonograms, id: \.self) { item in
//                            Text(item)
//                        }
//                    }
//                }
//                LatLonDisplayView(markerIndex: markerIndex)
//            }//List
//            .font(.title2)
//            .frame(width: 300,height: 130)
//            .listStyle(.plain)
//            .cornerRadius(15)
//            if .now < timerModel.firstClueArrivalTime {
//                Button {
//                    if markerModel.data.markers[markerIndex].monogram != "?" && !markerModel.data.startingClueSet {
//                        timerModel.setFirstClueArrivalTime()
//                        markerModel.markStartingClue(monogram: markerModel.data.markers[markerIndex].monogram)
//                    } else {
//                        AudioServicesPlaySystemSound(SystemSoundID(BUTTON_ERROR_SOUND))
//                    }
//                } label: {Text("Found")}
//                    .frame(width: 220, height: 65)
//                    .buttonStyle(.borderedProminent)
//                    .tint(.mapButton)
//                    .font(.title3)
//                    .foregroundColor(.white)
//            }
//        }//VStack
//    }
//}
//
//#Preview {
//    let markerModel = MarkerModel()
//    let timerModel = TimerModel()
//    markerModel.newMarker(location: GRID_CENTER)
//    markerModel.selection = 0
//    return StartingClueView(markerIndex: 0)
//        .environment(markerModel)
//        .environment(timerModel)
//
//}
