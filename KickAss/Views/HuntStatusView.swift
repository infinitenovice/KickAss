//
//  HuntStatusView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import SwiftUI

struct HuntStatusView: View {
    
    @State var huntClockColor: Color = Color(.green)
    @State var clueClockColor: Color = Color(.gray)
    @State var huntStatsColor: Color = Color(.gray)

    var body: some View {
        VStack {
            Spacer()
            HStack {
                HStack {
                    Text("Hunt")
//                    Text(huntModel.huntTimeDisplay)
                }
                .foregroundStyle(Color(huntClockColor))
                .frame(width: 170, alignment: .leading)
                .padding(.leading)
                Spacer()
                HStack {
                    Text("Clue")
//                    Text(huntModel.clueTimeDisplay)
                }
                .foregroundStyle(Color(clueClockColor))
                .frame(width: 120, alignment: .leading)
                .padding(.leading)
                Spacer()
                HStack {
                    Text("Stats")
//                    Text(huntModel.huntStatsDisplay)
                }
                .foregroundStyle(Color(huntStatsColor))
                .frame(width: 170, alignment: .trailing)
                .padding(.trailing)
            }
            .font(.system(size: 20))
            .frame(width: 600, alignment: .center)
            .foregroundColor(.white)
            .font(.title2)
            .background(Color.black)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            .cornerRadius(15)
            
        }
//        .onReceive(huntModel.timer) { _ in
////            huntModel.updateTimers()
//        }
//        .onChange(of: huntModel.huntState) { oldValue, newValue in
//            switch newValue {
//            case .NotStarted:
//                break
//            case .InProgress:
//                huntClockColor = Color.white
//                clueClockColor = Color.white
//                huntStatsColor = Color.white
//            case .Penalty:
//                clueClockColor = Color.gray
//                huntClockColor = Color.red
//            case .Ended:
//                huntStatsColor = Color.blue
//                clueClockColor = Color.gray
//                huntClockColor = Color.gray
//
//            }
//        }
        
    }
}

#Preview {
    return HuntStatusView()
}
