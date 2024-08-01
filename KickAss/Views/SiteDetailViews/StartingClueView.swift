//
//  StartingClueView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//

import SwiftUI
import AVFoundation

struct StartingClueView: View {
    let markerIndex: Int

    @Environment(SiteMarkerModel.self) var siteMarkerModel
    @Environment(TimerModel.self) var timerModel

    var body: some View {
        @Bindable var siteMarkerModel = siteMarkerModel

        VStack{
            List {
                if timerModel.firstClueArrivalTime < .now {
                    Text("Clue \(siteMarkerModel.markers[markerIndex].monogram)")
                    Text("Starting Clue Site Found")
                } else {
                    Text("Starting Clue Site")
                    Picker("Clue Letter", selection: $siteMarkerModel.markers[markerIndex].monogram) {
                        ForEach(siteMarkerModel.ClueLetterMonograms, id: \.self) { item in
                            Text(item)
                        }
                    }
                }
            }//List
            .font(.title2)
            .frame(width: 300,height: 90)
            .listStyle(.plain)
            .cornerRadius(15)
            if .now < timerModel.firstClueArrivalTime {
                Button {
                    if siteMarkerModel.markers[markerIndex].monogram != "?" && !siteMarkerModel.startingClueSet {
                        timerModel.setFirstClueArrivalTime()
                        siteMarkerModel.markStartingClue(monogram: siteMarkerModel.markers[markerIndex].monogram)
                    } else {
                        AudioServicesPlaySystemSound(SystemSoundID(BUTTON_ERROR_SOUND))
                    }
                } label: {Text("Found")}
                    .frame(width: 220, height: 50)
                    .buttonStyle(.borderedProminent)
                    .tint(.mapButton)
                    .font(.title3)
                    .foregroundColor(.white)
            }
        }//VStack
    }
}

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    let timerModel = TimerModel()
    siteMarkerModel.newMarker(location: GRID_CENTER)
    siteMarkerModel.selection = 0
    return StartingClueView(markerIndex: 0)
        .environment(siteMarkerModel)
        .environment(timerModel)

}
