//
//  JackAssSiteView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//

import SwiftUI

struct JackAssSiteView: View {
    var markerIndex: Int
    
    @Environment(SiteMarkerModel.self) var siteMarkerModel

    
    var body: some View {
        VStack{
            List {
                Text("Jackass Site")
            }//List
            .font(.title2)
            .frame(width: 300,height: 45)
            .listStyle(.plain)
            .cornerRadius(15)
            Button {
                siteMarkerModel.markers[markerIndex].deleted = true
                siteMarkerModel.markers[markerIndex].method = .NotFound
                siteMarkerModel.markers[markerIndex].monogram = "?"
                siteMarkerModel.selection = nil
            } label: {Text("Delete")}
                .frame(width: 220, height: 50)
                .buttonStyle(.borderedProminent)
                .tint(.mapButton)
                .font(.title3)
                .foregroundColor(.white)
        }//VStack
    }
}

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    siteMarkerModel.newMarker(location: GRID_CENTER)
    siteMarkerModel.selection = 0
    return JackAssSiteView(markerIndex: 0)
        .environment(siteMarkerModel)
}
