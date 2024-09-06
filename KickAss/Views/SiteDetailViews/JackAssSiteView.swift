//
//  JackAssSiteView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//
//
//import SwiftUI
//
//struct JackAssSiteView: View {
//    var markerIndex: Int
//    
//    @Environment(MarkerModel.self) var markerModel
//
//    
//    var body: some View {
//        VStack{
//            List {
//                Text("Jackass Site")
//            }//List
//            .font(.title2)
//            .frame(width: 300,height: 45)
//            .listStyle(.plain)
//            .cornerRadius(15)
//            Button {
//                markerModel.data.markers[markerIndex].deleted = true
//                markerModel.data.markers[markerIndex].found = false
//                markerModel.data.markers[markerIndex].emergency = false
//                markerModel.data.markers[markerIndex].monogram = "?"
//                markerModel.selection = nil
//            } label: {Text("Delete")}
//                .frame(width: 220, height: 50)
//                .buttonStyle(.borderedProminent)
//                .tint(.mapButton)
//                .font(.title3)
//                .foregroundColor(.white)
//        }//VStack
//    }
//}
//
//#Preview {
//    let markerModel = MarkerModel()
//    markerModel.newMarker(location: GRID_CENTER)
//    markerModel.selection = 0
//    return JackAssSiteView(markerIndex: 0)
//        .environment(markerModel)
//}
