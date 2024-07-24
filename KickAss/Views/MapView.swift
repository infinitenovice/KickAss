//
//  MapView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    var body: some View {
        ZStack {
            MapReader { proxy in
                Map() {
                    
                }//Map
                .mapStyle(.hybrid)
                .mapControlVisibility(.hidden)
            }//MapReader
        }//ZStack
    }//body
}//MapView

#Preview {
    MapView()
}
