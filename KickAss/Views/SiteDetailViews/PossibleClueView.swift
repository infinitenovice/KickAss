//
//  PossibleClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//
//
//import SwiftUI
//
//struct PossibleClueView: View {
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
//                Text("Possible Clue Site")
//                Picker("Clue Letter", selection: $markerModel.data.markers[markerIndex].monogram) {
//                    ForEach(markerModel.ClueLetterMonograms, id: \.self) { item in
//                        Text(item)
//                    }
//                }
//                TextField("Marker Label", text: $markerModel.data.markers[markerIndex].title)
//                LatLonDisplayView(markerIndex: markerIndex)
//            }//List
//            .listStyle(.plain)
//            .font(.title2)
//            .cornerRadius(15)
//            .frame(width: 300,height: 170)
//        }//VStack
//        HStack {
//            ScrollView(.horizontal) {
//                LazyHStack {
//                    Button {
//                        markerModel.markSiteFound(markerIndex: markerIndex)
//                        timerModel.resetClueTimer()
//                        } label: {Text("Found")}
//                            .frame(width: 220, height: 50)
//                            .buttonStyle(.borderedProminent)
//                            .tint(.mapButton)
//                            .font(.title3)
//                            .foregroundColor(.white)
//                    Button {
//                        markerModel.markSiteFound(markerIndex: markerIndex)
//                        timerModel.resetClueTimer()
//                        } label: {Text("Emergency")}
//                            .frame(width: 220, height: 50)
//                            .buttonStyle(.borderedProminent)
//                            .tint(.mapButton)
//                            .font(.title3)
//                            .foregroundColor(.white)
//                     Button {
//                        markerModel.data.markers[markerIndex].type = .JackassSite
//                        markerModel.data.markers[markerIndex].monogram = "JA"
//                         markerModel.selection = nil
//                        } label: {Text("Jackass!")}
//                            .frame(width: 220, height: 50)
//                            .buttonStyle(.borderedProminent)
//                            .tint(.mapButton)
//                            .font(.title3)
//                            .foregroundColor(.white)
//                    Button {
//                        markerModel.data.markers[markerIndex].deleted = true
//                        markerModel.data.markers[markerIndex].monogram = "?"
//                        markerModel.selection = nil
//                        } label: {Text("Delete")}
//                            .frame(width: 220, height: 50)
//                            .buttonStyle(.borderedProminent)
//                            .tint(.mapButton)
//                            .font(.title3)
//                            .foregroundColor(.white)
//                }
//                .scrollTargetLayout()
//            }
//            .scrollTargetBehavior(.viewAligned)
//        }.frame(width: 230, height: 70)
//    }
//}
//
////#Preview {
////    let timerModel = TimerModel()
////    let markerModel = MarkerModel()
////    markerModel.newMarker(location: GRID_CENTER)
////    markerModel.selection = 0
////    return PossibleClueView(markerIndex: 0)
////        .environment(markerModel)
////        .environment(timerModel)
////}
