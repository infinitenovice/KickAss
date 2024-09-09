//
//  LongPressMenuView.swift
//  KickAss
//
//  Created by Infinite Novice on 9/6/24.
//

import SwiftUI

struct LongPressMenuView: View {
    var markerIndex: Int
    @Binding var isShowing: Bool
    
    @Environment(MarkerModel.self) var markerModel
    
    var body: some View {
        
        VStack{
            Button {
                markerModel.jackassMarker(markerIndex: markerIndex)
                isShowing = false
            } label: {
                Text("Jackass!")
            }
            .padding(.top)
            Button {
                markerModel.deleteMarker(markerIndex: markerIndex)
                isShowing = false
            } label: {
                Text("Delete Marker")
            }
            .padding()
        }
        .buttonStyle(.borderedProminent)
        .tint(Color.theme.backgroundSecondary)
        .background(Color.theme.backgroundTertiary)
    }
}

