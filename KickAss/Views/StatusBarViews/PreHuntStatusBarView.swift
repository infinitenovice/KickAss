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
        HStack {
            Text(huntInfoModel.huntInfo.huntTitle)
            if abs(timerModel.huntTimeElapsed) > 24*60*60  {
                Text(huntInfoModel.huntInfo.huntStartDate, format: .dateTime.day().month().year())
            } else {
                Text(huntCountdownString(interval: abs(timerModel.huntTimeElapsed)))
            }
        }
    }
    func huntCountdownString(interval: Int) -> String {
        var intervalString = ""

        let hours = interval/Hour
        let minutes = (interval%Hour)/Minute
        let seconds = interval%Minute
        intervalString += String(format: "%0.2d:%0.2d:%0.2d", hours, minutes, seconds)
        return intervalString
    }
}

