//
//  CheckInView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//
//
//import SwiftUI
//
//struct CheckInView: View {
//    @Environment (TimerModel.self) var timerModel
//    @Environment (MarkerModel.self) var markerModel
//    var body: some View {
//        VStack{
//            List {
//                Text("Check In Site")
//                Text("West World")
//            }//List
//            .font(.title2)
//            .frame(width: 300,height: 90)
//            .listStyle(.plain)
//            .cornerRadius(15)
//            if .now < timerModel.checkInTime {
//                Button {
//                    timerModel.checkIn()
//                    markerModel.selection = nil
//                } label: {Text("Check In")}
//                    .frame(width: 220, height: 50)
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
//    let timerModel = TimerModel()
//    let markerModel = MarkerModel()
//    return CheckInView()
//        .environment(timerModel)
//        .environment(markerModel)
//}
