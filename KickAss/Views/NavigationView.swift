//
//  NavigationView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI
import MapKit

struct NavigationView: View {
//    @Environment(MapModel.self) var mapModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(TimerModel.self) var timerModel
//    @Environment(LocationManager.self) var locationManager

    var body: some View {
        HStack {
            VStack {
                Spacer(minLength: 500)
                VStack {
                    HStack {
                        Text(String(Int((navigationModel.stepRemainingDistance ?? 0)*FEET_PER_METER))+" ft")
                            .frame(width: 190, alignment: .leading)
                            .padding()
                        Spacer()
                        Button {
                            navigationModel.clearRoute()
                        }label: {
                            Image(systemName: "xmark.circle")
                        }
                        .foregroundColor(.white)
                        .padding(.trailing)
                    }
                    .font(.title2)
  
                    VStack {
                        Text(navigationModel.stepInstructions ?? "End of route")
                            .font(.title2)
                            .lineLimit(2)
                            .frame(width: 280,height: 70, alignment: .leading)
                            .padding(.leading)
                        HStack {
                            if let route = navigationModel.route {
                                let arrivalTime = Date.now.addingTimeInterval(route.expectedTravelTime) 
                                Text("ETA ")
                                    .font(.footnote)
                                Text(arrivalTime, format: .dateTime.hour().minute())
                                    .font(.footnote)
                            }
                        }
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(width: 300, height:160, alignment: .leading)
                .background(.black)
                .cornerRadius(15)
//                Spacer()
                .padding(.bottom)
                .padding(.bottom)
                .padding(.bottom)
            }
            Spacer()
        }
        .padding(.leading)
//        .onChange(of: locationManager.userLocation) { oldValue, newValue in
//            navigationModel.updateStepRemainingDistance(locationManager: locationManager)
//        }
    }
}

