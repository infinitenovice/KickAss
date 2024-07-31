//
//  HuntStatusView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct oldHuntStatusView: View {
    @Environment (TimerModel.self) var timerModel
    @Environment (SiteMarkerModel.self) var siteMarkerModel

    var body: some View {
        VStack {
            Spacer()
            HStack {
                HStack {
                    Text("Hunt")
                    Text(huntIntervalDisplayString(interval: timerModel.huntTimeElapsed))
                }
                .frame(width: 170, alignment: .leading)
                .padding(.leading)
                Spacer()
                HStack {
                    Text("Clue")
                    Text(clueIntervalDisplayString(interval: timerModel.clueTimeElapsed))
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
    func huntIntervalDisplayString(interval: Int) -> String {
        var intervalString = ""
        if interval < 0 {
            intervalString = "T-"
            let days = abs(interval/Day)
            if days > 1 {
                intervalString += String(format: "%0.1d Days", days)
            } else {
                let hours = abs(interval/Hour)
                let minutes = abs((interval%Hour)/Minute)
                let seconds = abs(interval%Minute)
                intervalString += String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds)
            }
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
    func clueIntervalDisplayString(interval: Int) -> String {
        let minutes = abs(interval/Minute)
        let seconds = abs(interval%Minute)
        return String(format: "%0.1d:%0.2d", minutes, seconds)
    }
    func statsString(stickers: Int, emergencies: Int, sequenceGaps: Int) -> String {
        var clueCredits: Double = 0
        var aveClueTime: Double = 0
        var stickerCount: Int = stickers
//        var sequenceGaps: Int = 0
//        var emergencies: Int = 0
        
        stickerCount -= 1 //The start clue sticker doesn's count
        clueCredits = Double(stickerCount)-Double(sequenceGaps)/2
//        if clueCredits != 0 {
//                aveClueTime = ((Double(timerModel.elapsedHuntTimeAdjusted()) + Double(emergencies * 20)) / clueCredits) / 60
//        }
        
        return String(format: "F%1d-E%1d-%2.1f",stickerCount,emergencies,aveClueTime)

    }
}

#Preview {
    let timerModel = TimerModel()
    let siteMarkerModel = SiteMarkerModel()
    return oldHuntStatusView()
        .environment(timerModel)
        .environment(siteMarkerModel)
}
