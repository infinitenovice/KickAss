//
//  FoundClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI

struct FoundClueView: View {
    let markerIndex: Int

    @Environment(SiteMarkerModel.self) var siteMarkerModel
    
    var body: some View {
        VStack{
            List {
                Text("Found:  Clue \(siteMarkerModel.markers[markerIndex].monogram)")
                Text("Method: \(siteMarkerModel.markers[markerIndex].method.rawValue)")
            }//List
            .font(.title2)
            .frame(width: 300,height: 90)
            .listStyle(.plain)
            .cornerRadius(15)
            Button {
                siteMarkerModel.markers[markerIndex].type = .PossibleClueSite
                siteMarkerModel.markers[markerIndex].method = .NotFound
            } label: {Text("Edit")}
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
    siteMarkerModel.newMarker(location: GridCenter)
    siteMarkerModel.selection = 0
    return FoundClueView(markerIndex: 0)
        .environment(siteMarkerModel)

}
