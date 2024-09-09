//
//  SiteMarkerModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import CoreLocation
import SwiftUI
import AVFoundation
import OSLog


@Observable
class MarkerModel {
    static let shared = MarkerModel()
    var log = Logger(subsystem: "KickAss", category: "MarkerModel")
    
    var data: SavedData = SavedData(markers: [])
    
    var selection: Int?
    var refresh: Bool = false
    var showRangeRadius: Bool = true
    var rangeRadius: Double = SEARCH_RADIUS

    private init() {}  //Limit instantiaion to singleton
    
    struct SavedData : Codable {
        var markers: [SiteMarker] = []
    }
    
    struct SiteMarker: Identifiable, Codable {
        var id: Int                         = 0
        var type: SiteType                  = .ClueSite
        var latitude: CLLocationDegrees     = 0.0
        var longitude: CLLocationDegrees    = 0.0
        var found: Bool                     = false
        var emergency: Bool                 = false
        var monogram: String                = ""
        var title: String                   = ""
        var deleted: Bool                   = false
    }
    enum SiteType: Codable {
        case CheckInSite
        case StartClueSite
        case ClueSite
        case JackassSite
    }

    let ClueLetterMonograms: [String] = [
        "?","A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    ]
    func validMarker(markerIndex: Int) -> Bool {
        if markerIndex >= 0 && markerIndex < data.markers.count {
            return true
        } else {
            log.info("Invalid marker index: \(markerIndex)")
            return false
        }
    }
    func deleteMarker(markerIndex: Int) {
        data.markers[markerIndex].monogram = ""
        data.markers[markerIndex].deleted = true
        selection = nil
        save()
    }
    func jackassMarker(markerIndex: Int) {
        data.markers[markerIndex].monogram = "JA"
        data.markers[markerIndex].type = .JackassSite
        data.markers[markerIndex].title = "Jackass!"
        save()
    }
    func markAsFound(markerIndex: Int) {
        if validMarker(markerIndex: markerIndex) {
            data.markers[markerIndex].found = true
        }
    }
    func newMarker(type: SiteType = .ClueSite, location: CLLocationCoordinate2D, monogram: String = "?", title: String = "", airDroppedMarker: Bool = false) {
        let marker: SiteMarker = SiteMarker(
            id:             data.markers.count,
            type:           type,
            latitude:       location.latitude,
            longitude:      location.longitude,
            found:          false,
            emergency:      false,
            monogram:       monogram,
            title:          title
            )
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
            if data.markers[index].found || data.markers[index].type == .StartClueSite {
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
    
    func markerColor(marker: SiteMarker) -> Color {
        switch marker.type {
        case .CheckInSite:
            return Color.theme.markerRequired
        case .StartClueSite:
            return Color.theme.markerRequired
        case .ClueSite:
            if marker.emergency {
                return Color.theme.markerEmergency
            } else if marker.found {
                return Color.theme.markerFound
            } else {
                return Color.theme.markerDefault
            }
        case .JackassSite:
            return Color.theme.markerJackass
        }
    }
    func deleteAllMarkers() {
        data.markers.removeAll()
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
                log.error("\(error.localizedDescription)")
            }
        }
        if data.markers.isEmpty {
            log.info("creating required markers")
            newMarker(type: .CheckInSite, location: CHECK_IN_SITE, monogram: "WW", title: "West World")
            newMarker(type: .StartClueSite, location: GRID_CENTER, monogram: "?", title: "Start Clue")
        }
    }
    func save() {
        do {
            let fileData = try JSONEncoder().encode(data)
            try fileData.write(to: SITE_MARKERS_URL)
        } catch {
            log.error("\(error.localizedDescription)")
        }
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
