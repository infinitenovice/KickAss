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
    var elapsedHuntTime: Int = 0
    var elapsedClueTime: Int = 0
    private var huntStart: Date = .now
    private var clueStart: Date = .now
    private var clueTimerActive: Bool = false

    
    let calendar = Calendar.current
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    func updateTimers() {
        elapsedHuntTime = calendar.dateComponents([.second], from: huntStart, to: .now).second ?? 0
        if elapsedHuntTime == 0 {
            resetClueTimer()
        }
        if clueTimerActive {
            elapsedClueTime = calendar.dateComponents([.second], from: clueStart, to: .now).second ?? 0
        }
        print(elapsedHuntTime)
    }
    func setHuntStartTime(start: Date) {
        huntStart = start
    }
    func resetClueTimer() {
        clueStart = .now
        clueTimerActive = true
    }
    func stopClueTimer() {
        clueTimerActive = false
        elapsedClueTime = 0
    }
    func huntIntervalDisplayString(interval: Int) -> String {
        var intervalString = ""
        if interval < 0 {
            intervalString = "T-"
            let days = abs(interval/Day)
            if days > 1 {
                intervalString += String(format: "%0.1d Days", days)
            } else {
                let hours = abs(interval/Hour)
                let minutes = abs((interval%Hour)/Minute)
                let seconds = abs(interval%Minute)
                intervalString += String(format: "%0.1d:%0.2d:%0.2d", hours, minutes, seconds)
            }
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
    func clueIntervalDisplayString(interval: Int) -> String {
        let minutes = abs(interval/Minute)
        let seconds = abs(interval%Minute)
        return String(format: "%0.1d:%0.2d", minutes, seconds)
    }
}
