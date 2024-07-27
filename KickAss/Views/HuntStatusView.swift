//
//  HuntStatusView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct HuntStatusView: View {
    @Environment (TimerModel.self) var timerModel

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
//                    Text(huntModel.huntStatsDisplay)
                }
                .frame(width: 170, alignment: .trailing)
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
}

#Preview {
    let timerModel = TimerModel()
    return HuntStatusView()
        .environment(timerModel)
}
