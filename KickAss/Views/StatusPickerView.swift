//
//  StatusPickerView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import SwiftUI

struct StatusPickerView: View {
    let markerIndex: Int
    
    @Environment(SiteMarkerModel.self) var siteMarkerModel
    
    @State var pickerSelection: SiteMarkerModel.ClueSiteMonogram = .Jackass
    
    var body: some View {
        @Bindable var siteMarkerModel = siteMarkerModel
            VStack{
                List {
                    Picker("Site Status", selection: $siteMarkerModel.markers[markerIndex].status) {
                        ForEach(SiteMarkerModel.SiteStatus.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                    Picker("Clue Letter", selection: $siteMarkerModel.markers[markerIndex].monogram) {
                        ForEach(SiteMarkerModel.ClueSiteMonogram.allCases) { item in
                            Text(item.rawValue)
                        }
                    }
                }//List
                .frame(width: 300,height: 90)
                .listStyle(.plain)
                .cornerRadius(15)
            }//VStack
    }//body
}//View

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    siteMarkerModel.newMarker(location: GridCenter)
    return StatusPickerView(markerIndex: 0)
        .environment(siteMarkerModel)
}
