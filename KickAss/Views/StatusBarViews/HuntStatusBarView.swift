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
            VStack {
                Text("Hunt")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
                Text(huntTimeDisplay(interval: timerModel.huntTimeElapsed))
                    .monospacedDigit()
                    .padding([.leading,.trailing])
            }
            .padding(.leading)
            Spacer()
            VStack {
                Text("Clue")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
                Text(clueTimeDisplay(interval: timerModel.clueTimeElapsed))
                    .monospacedDigit()
                    .padding([.leading,.trailing])
            }
            Spacer()
            VStack {
                Text("Found")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
                Text("\(statisticsModel.cluesFound)")
                    .monospacedDigit()
                    .padding([.leading,.trailing])
            }
            Spacer()
            VStack {
                Text("Emergencies")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
                Text("\(statisticsModel.emergenciesUsed)")
                    .monospacedDigit()
                    .padding([.leading,.trailing])
            }
            Spacer()
            VStack {
                Text("Average Time")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.textSecondary)
                Text(String(format: "%2.1f",averageClueTime()))
                    .monospacedDigit()
                    .padding([.leading,.trailing])
            }
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
    func averageClueTime() -> Double {
        var aveClueTime: Double = 0
        if statisticsModel.cluesFound > 0 {
            let adjustedHuntTime = timerModel.huntTimeElapsed - timerModel.firstClueCredit() - timerModel.lastClueCredit + timerModel.penaltyTime() + statisticsModel.emergenciesUsed*20
            if statisticsModel.clueCredits > 0 {
                aveClueTime = (Double(adjustedHuntTime) / statisticsModel.clueCredits) / 60
            }
        }
        return aveClueTime
    }
}

