//
//  TestScrollButtonList.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI

struct ScrollButtonView: View {
    let markerIndex: Int

    @Environment(SiteMarkerModel.self) var siteMarkerModel
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    Button {
                        
                        } label: {Text("Found (Solved)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        
                        } label: {Text("Found (Emergency)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        
                        } label: {Text("Found (Out of Order)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                     Button {
                        
                        } label: {Text("Jackass!")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        siteMarkerModel.markers[markerIndex].deleted = true
                        } label: {Text("Delete")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                }
                .scrollTargetLayout()
            }
//            .contentMargins(16, for: .scrollContent)
            .scrollTargetBehavior(.viewAligned)
        }.frame(width: 230, height: 70)
    }
}

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    siteMarkerModel.newMarker(location: GridCenter)
    siteMarkerModel.selection = 0
    return ScrollButtonView(markerIndex: 0)
        .environment(siteMarkerModel)
}
