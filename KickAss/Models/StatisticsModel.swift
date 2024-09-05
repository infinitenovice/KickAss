//
//  StatisticsModel.swift
//  KickAss
//
//  Created by Infinite Novice on 9/5/24.
//

import Foundation

@Observable
class StatisticsModel {
    let markerModel = MarkerModel.shared
    
    var cluesFound: Int = 0
    var emergenciesUsed: Int = 0
    var clueCredits: Double = 0.0
        
    func update() {
        var clueStickers: [String] = []
        var startClueMonogram: String?
        var emergencyCount = 0
        var gapCount = 0
        
        if markerModel.data.startingClueSet {
            for index in 0..<markerModel.data.markers.count {
                if markerModel.data.markers[index].found {
                    clueStickers.append(markerModel.data.markers[index].monogram)
                    if markerModel.data.markers[index].emergency {
                        emergencyCount += 1
                    }
                    if markerModel.data.markers[index].type == .StartClueSite {
                        startClueMonogram = markerModel.data.markers[index].monogram
                    }
                }
            }
            clueStickers.sort()
            if !clueStickers.isEmpty {
                if let startClueMonogram = startClueMonogram {
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
                        gapCount += 1
                    }
                }
            }
        }
        if clueStickers.count <= 1 {
            cluesFound = 0
        } else {
            cluesFound = clueStickers.count-1
        }
        emergenciesUsed = emergencyCount
        clueCredits = Double(cluesFound)-Double(gapCount)*0.5
        print("Clues Found:\(cluesFound) Emergencies:\(emergenciesUsed) Clue Credits:\(clueCredits)")
    }
}
