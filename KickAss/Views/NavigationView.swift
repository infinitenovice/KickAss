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
    @Environment(NavigationModel.self) var navigation
    @Environment(LocationManager.self) var locationManager

    var body: some View {
        HStack {
            VStack {
                Spacer(minLength: 500)
                VStack {
                    HStack {
                        Button {
                            navigation.nextStep()
                        } label: {
                            Text("Step")
                                .padding(.leading)
                        }
                        Spacer()
                        Text(String(Int((navigation.stepRemainingDistance ?? 0)*FeetPerMeter))+" ft")
                        Spacer()
                        Button {
                            navigation.clearRoute()
                        }label: {
                            Image(systemName: "xmark.circle")
                        }
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                    }
  
                    VStack {
                        Text(navigation.stepInstructions ?? "End of Route")
                            .lineLimit(2)
                    }
                    Spacer()
                }
                .foregroundStyle(.white)
                .frame(width: 300, height:140, alignment: .leading)
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
        .onChange(of: locationManager.userLocation) { oldValue, newValue in
            navigation.updateStepRemainingDistance(locationManager: locationManager)
        }
    }
}

#Preview {
//    let map = MapModel()
    let navigation = NavigationModel()
    let locationManager = LocationManager()
    return NavigationView()
//        .environment(map)
        .environment(navigation)
        .environment(locationManager)
}
