//
//  NavigationView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI
import MapKit

struct NavigationView: View {
    @Environment(NavigationModel.self) var navigationModel
    @Environment(TimerModel.self) var timerModel

    var body: some View {
        HStack {
            VStack {
                Spacer(minLength: 300)
                VStack {
                    HStack {
                        ZStack {
                            Circle()
                                .frame(width: 10)
                            Circle()
                                .stroke(lineWidth: 2)
                                .frame(width: 25)
                            Image(systemName: "arrow.forward")
                                .font(.system(size: 25, weight: .semibold))
                                .offset(x:15)
                        }
                        .foregroundColor(Color.theme.textSecondary)
                        .frame(width: 50)
                        if let monogram = navigationModel.destinationMonogram {
                            Text(monogram)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundStyle(Color.theme.textSecondary)
                        }
                        Spacer()
                        Button {
                            navigationModel.clearRoute()
                        }label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 25))
                        }
                    }
                    .padding()
                    VStack {
                        Text(String(Int((navigationModel.stepRemainingDistance ?? 0)*FEET_PER_METER))+" ft")
                        Text(navigationModel.stepInstructions ?? "End of route")
                            .font(.system(size: 20))
                            .lineLimit(3)
                            .frame(height: 80)
                            .padding([.trailing, .leading])
                        HStack {
                            if let route = navigationModel.route {
                                let arrivalTime = Date.now.addingTimeInterval(route.expectedTravelTime) 
                                Text("ETA ")
                                Text(arrivalTime, format: .dateTime.hour().minute())
                            }
                        }
                        .foregroundColor(Color.theme.textSecondary)
                        .padding()
                    }
                    .font(.system(size: 20))
                    Spacer()
                }
                .foregroundStyle(Color.theme.textPrimary)
                .frame(width: 250, height:250, alignment: .leading)
                .background(Color.theme.backgroundSecondary)
                .cornerRadius(15)
                .padding(.leading,12)
                .padding(.bottom,50)
            }
            Spacer()
        }
    }
}

