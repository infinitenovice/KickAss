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
                    .font(.title)
  
                    VStack {
                        Text(navigationModel.stepInstructions ?? "End of route")
                            .font(.title)
                            .lineLimit(2)
                            .frame(width: 280,height: 70, alignment: .leading)
                            .padding(.leading)
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(width: 300, height:150, alignment: .leading)
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

#Preview {
//    let map = MapModel()
    let navigationModel = NavigationModel()
    let locationManager = LocationManager()
    return NavigationView()
//        .environment(map)
        .environment(navigationModel)
        .environment(locationManager)
}
