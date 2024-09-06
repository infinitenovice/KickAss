//
//  ActiveStatusBarView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/30/24.
//

import SwiftUI

struct HuntStatusBarView: View {
    @Environment (TimerModel.self) var timerModel
    @Environment (MarkerModel.self) var markerModel
    @Environment (StatisticsModel.self) var statisticsModel
    
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
                Text(statsString(found: statisticsModel.cluesFound, emergencies: statisticsModel.emergenciesUsed, clueCredits: statisticsModel.clueCredits ))
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
    func statsString(found: Int, emergencies: Int, clueCredits: Double) -> String {
        var aveClueTime: Double = 0
        if found > 0 {
            let adjustedHuntTime = timerModel.huntTimeElapsed - timerModel.firstClueCredit() - timerModel.lastClueCredit + timerModel.penaltyTime() + emergencies*20
            if clueCredits > 0 {
                aveClueTime = (Double(adjustedHuntTime) / clueCredits) / 60
            }
        }
        return String(format: "F%1d E%1d %2.1f",found,emergencies,aveClueTime)

    }
}

