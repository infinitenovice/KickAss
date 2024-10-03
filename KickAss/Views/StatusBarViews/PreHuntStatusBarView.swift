//
//  PreHuntStatusBarView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/30/24.
//

import SwiftUI

struct PreHuntStatusBarView: View {
    @Environment(HuntInfoModel.self) var huntInfoModel
    @Environment(TimerModel.self) var timerModel
    let calendar = Calendar.current
    var body: some View {
        VStack {
            Text(huntCountdownString(interval: abs(timerModel.huntTimeElapsed)))
                .monospacedDigit()
            HStack {
                Text(huntInfoModel.huntInfo.huntTitle)
                Text("-")
                Text(huntInfoModel.huntInfo.huntTheme)
            }
            .font(.system(size: 10))
        }
    }
    func huntCountdownString(interval: Int) -> String {
        var intervalString = ""
        
        let days = interval/Day
        let hours = (interval%Day)/Hour
        let minutes = (interval%Hour)/Minute
        let seconds = interval%Minute
        intervalString += String(format: "%0.2d:%0.2d:%0.2d:%0.2d", days, hours, minutes, seconds)
        return intervalString
    }
}

