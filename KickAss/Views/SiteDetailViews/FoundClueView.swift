//
//  FoundClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import SwiftUI

struct FoundClueView: View {
    let markerIndex: Int

    @Environment(MarkerModel.self) var markerModel
    
    var body: some View {
        VStack{
            List {
                Text("Clue \(markerModel.data.markers[markerIndex].monogram)")
                Text(markerModel.data.markers[markerIndex].method.rawValue)
            }//List
            .font(.title2)
            .frame(width: 300,height: 90,alignment: .center)
            .listStyle(.plain)
            .cornerRadius(15)
            Button {
                markerModel.data.markers[markerIndex].type = .PossibleClueSite
                markerModel.data.markers[markerIndex].method = .NotFound
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
    let markerModel = MarkerModel()
    markerModel.newMarker(location: GRID_CENTER)
    markerModel.selection = 0
    return FoundClueView(markerIndex: 0)
        .environment(markerModel)

}
