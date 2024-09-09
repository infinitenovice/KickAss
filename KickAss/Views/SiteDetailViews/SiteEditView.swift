//
//  SiteEditView.swift
//  KickAss
//
//  Created by Infinite Novice on 9/4/24.
//

import SwiftUI
import MapKit

struct SiteEditView: View {
    let markerIndex: Int
    
    @Environment(MarkerModel.self) var markerModel
    @Environment(MapModel.self) var mapModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(HuntInfoModel.self) var huntInfoModel
    @Environment(TimerModel.self) var timerModel
    
    @State private var isShowingMessages = false

    var body: some View {
            HStack {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            markerModel.data.markers[markerIndex].latitude = mapModel.region().center.latitude
                            markerModel.data.markers[markerIndex].longitude = mapModel.region().center.longitude
                            markerModel.refresh.toggle()
                        } label: {
                            Image(systemName: "arrow.up.and.down.and.arrow.left.and.right")
                            //Image(systemName: "move.3d")
                        }
                        Spacer()
                        Button {
                            isShowingMessages = true
                            } label: {Image(systemName: "square.and.arrow.up")}
                            .sheet(isPresented: self.$isShowingMessages) {
                                MessageSender(recipients: huntInfoModel.phoneList(),
                                              message: "http://maps.apple.com/?ll="+String(markerModel.data.markers[markerIndex].latitude)+","+String(markerModel.data.markers[markerIndex].longitude))
                            }
                        
                        Spacer()
                        Button {
                            navigationModel.setDestination(destination: markerModel.data.markers[markerIndex])
                        } label: {Image(systemName: "car.circle")}
                        Spacer()
                    }//HStack
                    .buttonStyle(.borderedProminent)
                    .tint(Color.theme.backgroundSecondary)
                    .font(.title)
                    .foregroundColor(Color.theme.textPrimary)
                    .frame(width: 300,height: 50)
                    SiteInfoView(markerIndex: markerIndex)
                        .frame(width: 250, height: 180)
                    Spacer()
                }//VStack
                .frame(width: 275)
                Spacer()
            }//HStack
            .onDisappear() {
                markerModel.save()
            }
    }
}


