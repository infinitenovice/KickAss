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
            .frame(width: 600,  alignment: .center)
            .foregroundColor(Color.theme.textPrimary)
            .background(Color.theme.backgroundSecondary)
            .cornerRadius(15)
        }
    }
}

