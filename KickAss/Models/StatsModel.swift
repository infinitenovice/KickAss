//
//  StatisticsModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/27/24.
//

import Foundation

@Observable
class StatsModel {
    
    var stats: String = "F0-E0-00.0"
    var startClueCredit: Double = 0
    
    init() {
        
    }
    func updateStats(markers: [SiteMarkerModel.SiteMarker]) {
        var emergencies: Int = 0
        var clueCredits: Double = 0
        var gaps: Int = 0
        var aveClueTime: Double = 0
        var clueStickers: [String] = []
        var startClueMonogram: String = ""
        
        for index in 0..<markers.count {
            if markers[index].type == .FoundClueSite {
                clueStickers.append(markers[index].monogram)
                if markers[index].method == .Emergency {
                    emergencies += 1
                }
            }
            if markers[index].type == .StartClueSite {
                startClueMonogram = markers[index].monogram
                clueStickers.append(markers[index].monogram)
            }
        }
        if !clueStickers.isEmpty {
            clueStickers.sort()
            if startClueMonogram != "" {
                while clueStickers[0] != startClueMonogram {
                    let sticker = clueStickers[0]
                    clueStickers.removeFirst()
                    clueStickers.append(sticker)
                }
            }
            for index in 0..<clueStickers.count-1 {
                let currentCharValue = clueStickers[index].first?.asciiValue ?? 0
                let nextCharValue = clueStickers[index+1].first?.asciiValue ?? 0
                if currentCharValue != nextCharValue-1 {
                    gaps += 1
                }
            }
        }

        clueCredits = Double(clueStickers.count-1)-Double(gaps/2)
        aveClueTime = 0 //Double(adjustedHuntTime) / clueCredits
        print(clueCredits,aveClueTime)
        if gaps%2 == 0 {
            stats = String(format: "F%1d-E%1d-%1.2f",clueCredits,emergencies,aveClueTime)
        } else {
            stats = String(format: "F%1d.5-E%1d-%1.2f",clueCredits,emergencies,aveClueTime)
        }
    }
}
