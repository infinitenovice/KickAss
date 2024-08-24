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
class MarkerModel {
    
    var data: SavedData = SavedData(markers: [], startingClueSet: false, monogramLetterIndex: 0)
    
    var selection: Int?
    var emergencies: Int = 0
    var sequenceGaps: Int = 0
    var stickerCount: Int = 0
    var showRangeRadius: Bool = true
    var rangeRadius: Double = SEARCH_RADIUS
    
    struct SavedData : Codable {
        var markers: [SiteMarker] = []
        var startingClueSet: Bool = false
        var monogramLetterIndex: Int = 0
    }
    
    struct SiteMarker: Identifiable, Codable {
        var id: Int                         = 0
        var type: SiteType                  = .PossibleClueSite
        var latitude: CLLocationDegrees     = 0.0
        var longitude: CLLocationDegrees    = 0.0
        var method: MethodFound             = .NotFound
        var monogram: String                = ""
        var title: String                   = ""
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
        case Found              = "Clue Site Found"
        case Emergency          = "Pulled Emergency"
    }
    let ClueLetterMonograms: [String] = [
        "?","A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    ]
    func validMarker(markerIndex: Int) -> Bool {
        if markerIndex >= 0 && markerIndex < data.markers.count {
            return true
        } else {
            print("Invalid marker index:",markerIndex)
            return false
        }
    }
    func setNextMonogramLetter (monogram: String) {
        for index in 0..<ClueLetterMonograms.count {
            if ClueLetterMonograms[index] == monogram {
                data.monogramLetterIndex = index + 1
                if data.monogramLetterIndex == ClueLetterMonograms.count {
                    data.monogramLetterIndex = 1  // wrap from Z to A, skip "?"
                }
            }
        }
    }
    func markStartingClue(monogram: String) {
        data.startingClueSet = true
        setNextMonogramLetter(monogram: monogram)
    }
    func newMarker(type: SiteType = .PossibleClueSite, location: CLLocationCoordinate2D, monogram: String = "?", title: String = "", airDroppedMarker: Bool = false) {
        var marker: SiteMarker = SiteMarker(
            id:             data.markers.count,
            type:           type,
            latitude:       location.latitude,
            longitude:      location.longitude,
            method:         .NotFound,
            monogram:       monogram,
            title:          title
            )
        if data.startingClueSet && !airDroppedMarker {
            marker.monogram = ClueLetterMonograms[data.monogramLetterIndex]
        }
        data.markers.append(marker)
        if !airDroppedMarker {
            selection = marker.id
        }
        save()
    }
    func selectedMarkerCoordinates() -> CLLocationCoordinate2D? {
        if let selectedMarker = selection {
            return CLLocationCoordinate2D(latitude: data.markers[selectedMarker].latitude, longitude: data.markers[selectedMarker].longitude)
        } else {
            return nil
        }
    }
    func monogramValid(monogram: String) -> Bool {
        var markerPreviouslyUsed = false
        for index in 0..<data.markers.count {
            if data.markers[index].type == .FoundClueSite || data.markers[index].type == .StartClueSite {
                if monogram == data.markers[index].monogram {
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
        if monogramValid(monogram: data.markers[markerIndex].monogram) {
            data.markers[markerIndex].type = .FoundClueSite
            data.markers[markerIndex].method = method
            setNextMonogramLetter(monogram: data.markers[markerIndex].monogram)
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
        data.markers.removeAll()
        data.monogramLetterIndex = 0
        data.startingClueSet = false
        save()
        load()
    }
    func load() {
        if FileManager().fileExists(atPath: SITE_MARKERS_URL.path) {
            do {
                let jsonData = try Data(contentsOf: SITE_MARKERS_URL)
                let fileData = try JSONDecoder().decode(SavedData.self, from: jsonData)
                data = fileData
            } catch {
                print(error)
            }
        }
        if data.markers.isEmpty {
            print("creating required markers")
            newMarker(type: .CheckInSite, location: CHECK_IN_SITE, monogram: "WW", title: "West World")
            newMarker(type: .StartClueSite, location: GRID_CENTER, monogram: "?", title: "Start Clue")
        }
        updateStats()
    }
    func save() {
        do {
            let fileData = try JSONEncoder().encode(data)
            try fileData.write(to: SITE_MARKERS_URL)
        } catch {
            print(error)
        }
    }
    func updateStats() {
        var clueStickers: [String] = []
        var startClueMonogram: String = ""
        
        emergencies = 0
        sequenceGaps = 0
        
        for index in 0..<data.markers.count {
            if data.markers[index].type == .FoundClueSite {
                clueStickers.append(data.markers[index].monogram)
                if data.markers[index].method == .Emergency {
                    emergencies += 1
                }
            }
            if data.markers[index].type == .StartClueSite {
                startClueMonogram = data.markers[index].monogram
                clueStickers.append(data.markers[index].monogram)
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
    func processIncommingMarker(url: URL) {
        if let components = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let label = components.queryItems?[0].value ?? ""
            let coordString = components.queryItems?[1].value ?? ""
            let coords = coordString.components(separatedBy: ",")
            let lat = Double(coords[0]) ?? 0.0
            let lon = Double(coords[1]) ?? 0.0
            newMarker(location: CLLocationCoordinate2D(latitude: lat, longitude: lon), title: label, airDroppedMarker: true)
        }
    }
}
