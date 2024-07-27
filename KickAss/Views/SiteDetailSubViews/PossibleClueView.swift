//
//  PossibleClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI

struct PossibleClueView: View {
    let markerIndex: Int

    @Environment(SiteMarkerModel.self) var siteMarkerModel
    
    var body: some View {
        @Bindable var siteMarkerModel = siteMarkerModel

        VStack{
            List {
                Text("Possible Clue Site")
                Picker("Clue Letter", selection: $siteMarkerModel.markers[markerIndex].monogram) {
                    ForEach(siteMarkerModel.ClueLetterMonograms, id: \.self) { item in
                        Text(item)
                    }
                }
            }//List
            .font(.title2)
            .frame(width: 300,height: 90)
            .listStyle(.plain)
            .cornerRadius(15)
        }//VStack
        HStack {
            ScrollView(.horizontal) {
                LazyHStack {
                    Button {
                        siteMarkerModel.markers[markerIndex].type = .FoundClueSite
                        siteMarkerModel.markers[markerIndex].method = .Solved
                        } label: {Text("Found (Solved)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        siteMarkerModel.markers[markerIndex].type = .FoundClueSite
                        siteMarkerModel.markers[markerIndex].method = .Emergency
                        } label: {Text("Found (Emergency)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        siteMarkerModel.markers[markerIndex].type = .FoundClueSite
                        siteMarkerModel.markers[markerIndex].method = .OutOfOrder
                        } label: {Text("Found (Out of Order)")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                     Button {
                        siteMarkerModel.markers[markerIndex].type = .JackassSite
                        siteMarkerModel.markers[markerIndex].method = .NotFound
                        } label: {Text("Jackass!")}
                            .frame(width: 220, height: 50)
                            .buttonStyle(.borderedProminent)
                            .tint(.mapButton)
                            .font(.title3)
                            .foregroundColor(.white)
                    Button {
                        siteMarkerModel.markers[markerIndex].deleted = true
                        siteMarkerModel.markers[markerIndex].method = .NotFound
                        siteMarkerModel.markers[markerIndex].monogram = ""
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
    return PossibleClueView(markerIndex: 0)
        .environment(siteMarkerModel)
}
