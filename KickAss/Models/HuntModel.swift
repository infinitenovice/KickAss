//
//  HuntModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/25/24.
//

import Foundation

@Observable
class HuntModel {
    
    var huntState: HuntState        = HuntState.NotStarted
    var huntTimeDisplay: String     = "--:--:--"
    var clueTimeDisplay: String     = "--:-"
    var huntStatsDisplay: String    = "F- E- --.-"
    var clueStartTime: Date         = .now
    var checkInTime: Date           = .distantFuture

    let huntInfoURL = URL.documentsDirectory.appending(path: "HuntInfo.json")
    let calendar = Calendar.current
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    let HuntDuration = 20 //5*60*60+15
    var firstClueCredit: Int = 0

    init() {
        
    }
    
    enum HuntState {
        case NotStarted
        case InProgress
        case Penalty
        case Ended
    }
    
    func save() {
        
    }
    
    func updateTimers() {
        
    }
}
