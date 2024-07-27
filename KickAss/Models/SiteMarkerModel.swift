//
//  SiteMarkerModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import CoreLocation
import SwiftUI

@Observable
class SiteMarkerModel {
    var markers: [SiteMarker] = []
    var selection: Int?
    
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
        case Solved             = "Solved Clue"
        case Emergency          = "Pulled Emergency"
        case OutOfOrder         = "Out Of Order"
    }
    let ClueLetterMonograms: [String] = [
        "?","A","B","C","D","E","F","G","H","I","J","K","L","M",
        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"
    ]
    func newMarker(type: SiteType = .PossibleClueSite, location: CLLocationCoordinate2D, monogram: String = "?") {
        let marker: SiteMarker = SiteMarker(
            id:             markers.count,
            type:           type,
            latitude:       location.latitude,
            longitude:      location.longitude,
            method:         .NotFound,
            monogram:       monogram
            )
        markers.append(marker)
        save()
    }
    func selectedMarkerCoordinates() -> CLLocationCoordinate2D? {
        if let selectedMarker = selection {
            return CLLocationCoordinate2D(latitude: markers[selectedMarker].latitude, longitude: markers[selectedMarker].longitude)
        } else {
            return nil
        }
    }
    func markerColor(marker: SiteMarker) -> Color {
//        switch marker.type {
//        case .CheckInSite:
//            return Color.white
//        case .StartClueSite:
//            return Color.white
//        case .PossibleClueSite:
//            switch marker.status {
//            case .Undefined:
//                return Color.white
//            case .Found:
//                return Color.white
//            case .Emergency:
//                return Color.white
//            case .JackAss:
//                return Color.white
//            }
//        }
        return Color.white
    }
    func load() {
        if FileManager().fileExists(atPath: SiteMarkersURL.path) {
            do {
                let jsonData = try Data(contentsOf: SiteMarkersURL)
                let data = try JSONDecoder().decode([SiteMarker].self, from: jsonData)
                markers = data
            } catch {
                print(error)
            }
        }
        if markers.isEmpty {
            print("creating required markers")
            newMarker(type: .CheckInSite, location: WestWorld, monogram: "WW")
            newMarker(type: .StartClueSite, location: GridCenter, monogram: "SC")
        }
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(markers)
            try data.write(to: SiteMarkersURL)
        } catch {
            print(error)
        }
    }
}
