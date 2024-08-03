//
//  SiteMarkerModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import CoreLocation
import SwiftUI
import AVFoundation

@Observable
class SiteMarkerModel {
    
    var markers: [SiteMarker] = []
    var selection: Int?
    var emergencies: Int = 0
    var sequenceGaps: Int = 0
    var stickerCount: Int = 0
    var monogramLetterIndex: Int = 0
    var startingClueSet: Bool = false
    var showRangeRadius: Bool = true
    var rangeRadius: Double = SEARCH_RADIUS
    
    struct SiteMarker: Identifiable, Codable {
        var id: Int                         = 0
        var type: SiteType                  = .PossibleClueSite
        var latitude: CLLocationDegrees     = 0.0
        var longitude: CLLocationDegrees    = 0.0
        var method: MethodFound             = .NotFound
        var monogram: String                = ""
        var deleted: Bool                   = false
    }
    enum SiteType: Codable {
        case CheckInSite
        case StartClueSite
        case PossibleClueSite
        case FoundClueSite
        case JackassSite
    }
    enum MethodFound: String, Codable, CaseIterable {
        case NotFound           = "Possible Clue Site"
        case Found             = "Clue Site Found"
        case Emergency          = "Pulled Emergency"
    }
    let ClueLetterMonograms: [String] = [
        "?","A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    ]
    func validMarker(markerIndex: Int) -> Bool {
        if markerIndex >= 0 && markerIndex < markers.count {
            return true
        } else {
            print("Invalid marker index:",markerIndex)
            return false
        }
    }
    func setNextMonogramLetter (monogram: String) {
        for index in 0..<ClueLetterMonograms.count {
            if ClueLetterMonograms[index] == monogram {
                monogramLetterIndex = index + 1
                if monogramLetterIndex == ClueLetterMonograms.count {
                    monogramLetterIndex = 1  // wrap from Z to A, skip "?"
                }
            }
        }
    }
    func markStartingClue(monogram: String) {
        startingClueSet = true
        setNextMonogramLetter(monogram: monogram)
    }
    func newMarker(type: SiteType = .PossibleClueSite, location: CLLocationCoordinate2D, monogram: String = "?") {
        var marker: SiteMarker = SiteMarker(
            id:             markers.count,
            type:           type,
            latitude:       location.latitude,
            longitude:      location.longitude,
            method:         .NotFound,
            monogram:       monogram
            )
            if startingClueSet {
                marker.monogram = ClueLetterMonograms[monogramLetterIndex]
            }
        markers.append(marker)
        selection = marker.id
        save()
    }
    func selectedMarkerCoordinates() -> CLLocationCoordinate2D? {
        if let selectedMarker = selection {
            return CLLocationCoordinate2D(latitude: markers[selectedMarker].latitude, longitude: markers[selectedMarker].longitude)
        } else {
            return nil
        }
    }
    func monogramValid(monogram: String) -> Bool {
        var markerPreviouslyUsed = false
        for index in 0..<markers.count {
            if markers[index].type == .FoundClueSite {
                if monogram == markers[index].monogram {
                    markerPreviouslyUsed = true
                }
            }
        }
        if monogram == "?" || markerPreviouslyUsed {
            return false
        } else {
            return true
        }
    }
    func markSiteFound(markerIndex: Int, method: MethodFound) {
        if monogramValid(monogram: markers[markerIndex].monogram) {
            markers[markerIndex].type = .FoundClueSite
            markers[markerIndex].method = method
            setNextMonogramLetter(monogram: markers[markerIndex].monogram)
            updateStats()
        } else {
            AudioServicesPlaySystemSound(SystemSoundID(BUTTON_ERROR_SOUND))
        }
    }
    func markerColor(marker: SiteMarker) -> Color {
        switch marker.type {
        case .CheckInSite:
            return Color.white
        case .StartClueSite:
            return Color.white
        case .PossibleClueSite:
            return Color.green
        case .JackassSite:
            return Color.red
        case .FoundClueSite:
            switch marker.method {
            case .Found:
                return Color.blue
            case .Emergency:
                return Color.yellow
            case .NotFound:
                return Color.white
            }
        }
    }
    func deleteAllMarkers() {
        markers.removeAll()
        monogramLetterIndex = 0
        startingClueSet = false
        save()
        load()
    }
    func load() {
        if FileManager().fileExists(atPath: SITE_MARKERS_URL.path) {
            do {
                let jsonData = try Data(contentsOf: SITE_MARKERS_URL)
                let data = try JSONDecoder().decode([SiteMarker].self, from: jsonData)
                markers = data
            } catch {
                print(error)
            }
        }
        if markers.isEmpty {
            print("creating required markers")
            newMarker(type: .CheckInSite, location: CHECK_IN_SITE, monogram: CHECK_IN_MONOGRAM)
            newMarker(type: .StartClueSite, location: GRID_CENTER, monogram: "?")
        }
        updateStats()
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(markers)
            try data.write(to: SITE_MARKERS_URL)
        } catch {
            print(error)
        }
    }
    func updateStats() {
        var clueStickers: [String] = []
        var startClueMonogram: String = ""
        
        emergencies = 0
        sequenceGaps = 0
        
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
                    sequenceGaps += 1
                }
            }
        }
        stickerCount = clueStickers.count
    }
}
