//
//  TimerModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/26/24.
//

import Foundation

let Minute = 60 //Seconds
let Hour = 60*Minute
let Day = 24*Hour
let HuntDuration = 5*Hour+15*Minute

@Observable
class TimerModel {
    
    var huntTimeElapsed: Int = 0
    var clueTimeElapsed: Int = 0
    var huntStartTime: Date = .now
    var clueStartTime: Date = .now
    var firstClueArrivalTime: Date = .distantFuture
    var lastClueCredit: Int = 0
    var checkInTime: Date = .distantFuture
    var huntState: HuntState = .NotStarted
    private var clueTimerActive: Bool = false

    
    let calendar = Calendar.current
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    enum HuntState {
        case NotStarted
        case InProgress
        case Ended
    }
    func updateTimers() {
        let timeNow: Date = .now
        if huntState != .Ended {
            huntTimeElapsed = calendar.dateComponents([.second], from: huntStartTime, to: timeNow).second ?? 0
            if huntTimeElapsed == 0 {
                resetClueTimer()
            }
            if clueTimerActive {
                clueTimeElapsed = calendar.dateComponents([.second], from: clueStartTime, to: timeNow).second ?? 0
            }
        }
        if timeNow < huntStartTime {
            huntState = .NotStarted
        } else if timeNow < checkInTime {
            huntState = .InProgress
        } else {
            huntState = .Ended
        }
    }
    func checkIn() {
        checkInTime = .now
        lastClueCredit = clueTimeElapsed
        stopClueTimer()
    }
    func setHuntStartTime(start: Date) {
        huntStartTime = start
    }
    func resetClueTimer() {
        clueStartTime = .now
        clueTimerActive = true
    }
    func stopClueTimer() {
        clueTimerActive = false
        clueTimeElapsed = 0
    }
    func setFirstClueArrivalTime() {
        firstClueArrivalTime = .now
        resetClueTimer()
    }
    func penaltyTime() -> Int {
        if huntTimeElapsed > HuntDuration {
            return huntTimeElapsed - HuntDuration
        } else {
            return 0
        }
    }
    func firstClueCredit() -> Int {
        return calendar.dateComponents([.second], from: huntStartTime, to: firstClueArrivalTime).second ?? 0
    }
}
