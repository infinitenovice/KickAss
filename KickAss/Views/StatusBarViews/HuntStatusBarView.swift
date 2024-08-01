//
//  ActiveStatusBarView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/30/24.
//

import SwiftUI

struct HuntStatusBarView: View {
    @Environment (TimerModel.self) var timerModel
    @Environment (SiteMarkerModel.self) var siteMarkerModel
    
    var body: some View {
        HStack {
            HStack {
                Text("Hunt")
                Text(huntTimeDisplay(interval: timerModel.huntTimeElapsed))
            }
            .frame(width: 170, alignment: .leading)
            .padding(.leading)
            Spacer()
            HStack {
                Text("Clue")
                Text(clueTimeDisplay(interval: timerModel.clueTimeElapsed))
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
    }
    func huntTimeDisplay(interval: Int) -> String {
        var intervalString = ""
        if timerModel.huntState == .Ended {
            intervalString = "Ended"
        } else {
            let remainingTime = HuntDuration - interval
            if remainingTime < 0 {
                intervalString = "-"
            }
            let hours = abs(remainingTime/Hour)
            let minutes = abs((remainingTime%Hour)/Minute)
            let seconds = abs(remainingTime%Minute)
            intervalString += String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds)
        }
        return intervalString
    }
    func clueTimeDisplay(interval: Int) -> String {
        let minutes = abs(interval/Minute)
        let seconds = abs(interval%Minute)
        return String(format: "%0.1d:%0.2d", minutes, seconds)
    }
    func statsString(stickers: Int, emergencies: Int, sequenceGaps: Int) -> String {
        var clueCredits: Double = 0
        var aveClueTime: Double = 0
        var stickerCount: Int = stickers
        stickerCount -= 1 //The start clue sticker doesn's count
        if stickerCount > 0 {
            clueCredits = Double(stickerCount)-Double(sequenceGaps)/2
            let adjustedHuntTime = timerModel.huntTimeElapsed - timerModel.firstClueCredit() + timerModel.penaltyTime() + emergencies*20
            if clueCredits > 0 {
                aveClueTime = (Double(adjustedHuntTime) / clueCredits) / 60
            }
        } else {
            stickerCount = 0
        }
        return String(format: "F%1d E%1d %2.1f",stickerCount,emergencies,aveClueTime)

    }
}

#Preview {
    let siteMarkerModel = SiteMarkerModel()
    let huntInfoModel = HuntInfoModel()
    let timerModel = TimerModel()
    return HuntStatusBarView()
        .environment(huntInfoModel)
        .environment(timerModel)
        .environment(siteMarkerModel)
}
