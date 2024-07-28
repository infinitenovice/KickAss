//
//  HuntStatusView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct HuntStatusView: View {
    @Environment (TimerModel.self) var timerModel
    @Environment (SiteMarkerModel.self) var siteMarkerModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                HStack {
                    Text("Hunt")
                    Text(timerModel.huntIntervalDisplayString(interval: timerModel.elapsedHuntTime))
                }
                .frame(width: 170, alignment: .leading)
                .padding(.leading)
                Spacer()
                HStack {
                    Text("Clue")
                    Text(timerModel.clueIntervalDisplayString(interval: timerModel.elapsedClueTime))
                }
                .frame(width: 120, alignment: .leading)
                .padding(.leading)
                Spacer()
                HStack {
                    Text("Stats")
                    Text(statsString(stickers: siteMarkerModel.stickerCount, emergencies: siteMarkerModel.emergencies, sequenceGaps: siteMarkerModel.sequenceGaps ))
                }
                .frame(width: 200, alignment: .trailing)
                .padding(.trailing)
            }
            .font(.system(size: 20))
            .frame(width: 600, alignment: .center)
            .foregroundColor(.white)
            .font(.title2)
            .background(Color.black)
            .cornerRadius(15)
            
        }
    }
    func statsString(stickers: Int, emergencies: Int, sequenceGaps: Int) -> String {
        var clueCredits: Double = 0
        var aveClueTime: Double = 0
        var stickerCount: Int = stickers
//        var sequenceGaps: Int = 0
//        var emergencies: Int = 0
        
        stickerCount -= 1 //The start clue sticker doesn's count
        clueCredits = Double(stickerCount)-Double(sequenceGaps)/2
        if clueCredits != 0 {
                aveClueTime = ((Double(timerModel.elapsedHuntTimeAdjusted()) + Double(emergencies * 20)) / clueCredits) / 60
        }
        
        return String(format: "F%1d-E%1d-%2.1f",stickerCount,emergencies,aveClueTime)

    }
}

#Preview {
    let timerModel = TimerModel()
    let siteMarkerModel = SiteMarkerModel()
    return HuntStatusView()
        .environment(timerModel)
        .environment(siteMarkerModel)
}
