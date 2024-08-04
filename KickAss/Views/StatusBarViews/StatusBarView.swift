//
//  StatusBarView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/30/24.
//

import SwiftUI

let STATUS_BAR_WIDTH = 600.0

struct StatusBarView: View {
    @Environment (TimerModel.self) var timerModel

    var body: some View {
        VStack {
            Spacer()
            HStack{
                switch timerModel.huntState {
                case .NotStarted:
                    PreHuntStatusBarView()
                case .InProgress, .Ended:
                    HuntStatusBarView()
                }
            }
            .font(.system(size: 20))
            .frame(width: STATUS_BAR_WIDTH,  alignment: .center)
            .foregroundColor(.white)
            .font(.title2)
            .background(Color.black)
            .cornerRadius(15)
        }
    }
}

#Preview {
    let markerModel = MarkerModel()
    let huntInfoModel = HuntInfoModel()
    let timerModel = TimerModel()
    timerModel.huntState = .InProgress
    return StatusBarView()
        .environment(timerModel)
        .environment(huntInfoModel)
        .environment(markerModel)

}
