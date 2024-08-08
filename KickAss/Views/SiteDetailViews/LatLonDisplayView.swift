//
//  LatLonDisplayView.swift
//  KickAss
//
//  Created by Infinite Novice on 8/8/24.
//

import SwiftUI

struct LatLonDisplayView: View {
    let markerIndex: Int

    @Environment(MarkerModel.self) var markerModel

    var body: some View {
        @Bindable var markerModel = markerModel
        
        let formatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimumFractionDigits = 5
            return formatter
        }()
        
        HStack {
            Spacer()
            TextField("", value: $markerModel.data.markers[markerIndex].latitude, formatter: formatter)
                .font(.title3)
                .frame(width: 110)
            TextField("", value: $markerModel.data.markers[markerIndex].longitude, formatter: formatter)
                .font(.title3)
                .frame(width: 110)
            Spacer()
        }
        .frame(width: 300)
//        .border(Color.black)

//        Button {
//            
//        } label: {
//            HStack {
//                Spacer()
//                Text(String(format: "%0.5f", markerModel.data.markers[markerIndex].latitude))
//                Text(String(format: "%0.5f", markerModel.data.markers[markerIndex].longitude))
//                Spacer()
//            }
//            .font(.footnote)
//        }
    }
}

#Preview {
    let markerModel = MarkerModel()
    markerModel.newMarker(location: GRID_CENTER)
    markerModel.selection = 0
    return LatLonDisplayView(markerIndex: 0)
        .environment(markerModel)
}
