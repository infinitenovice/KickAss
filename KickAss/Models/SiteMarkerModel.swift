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
        var type: SiteType                  = .ClueSite
        var latitude: CLLocationDegrees     = 0.0
        var longitude: CLLocationDegrees    = 0.0
        var status: SiteStatus              = .Undefined
        var monogram: ClueSiteMonogram      = .Undefined
        var altMonogram: String             = ""
        var deleted: Bool                   = false
    }
    enum SiteType: Codable {
        case CheckInSite
        case StartClueSite
        case ClueSite
    }
    enum SiteStatus: String, Codable, CaseIterable, Identifiable {
        case Undefined          = "Possible Clue Site"
        case Found              = "Found Clue"
        case Emergency          = "Used Emergency"
        case JackAss            = "JackAss Site"
        var id: Self {self}
    }
    enum ClueSiteMonogram: String, Codable, CaseIterable, Identifiable {
        case Undefined = "?"
        case A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z
        case Jackass = "JA"
        var id: Self {self}
    }
    func newMarker(type: SiteType = .ClueSite, location: CLLocationCoordinate2D, altMonogram: String = "") {
        let marker: SiteMarker = SiteMarker(
            id:             markers.count,
            type:           type,
            latitude:       location.latitude,
            longitude:      location.longitude,
            status:         .Undefined,
            monogram:       .Undefined,
            altMonogram:    altMonogram
            )
        markers.append(marker)
        save()
    }
    func markerColor(marker: SiteMarker) -> Color {
        switch marker.type {
        case .CheckInSite:
            return Color.white
        case .StartClueSite:
            return Color.white
        case .ClueSite:
            switch marker.status {
            case .Undefined:
                return Color.white
            case .Found:
                return Color.white
            case .Emergency:
                return Color.white
            case .JackAss:
                return Color.white
            }
        }
    }
    func load() {
        print("loading....")
        if FileManager().fileExists(atPath: SiteMarkersFileURL.path) {
            do {
                let jsonData = try Data(contentsOf: SiteMarkersFileURL)
                let data = try JSONDecoder().decode([SiteMarker].self, from: jsonData)
                markers = data
            } catch {
                print(error)
            }
        }
        if markers.isEmpty {
            print("creating required markers")
            newMarker(type: .CheckInSite, location: WestWorld, altMonogram: "WW")
            newMarker(type: .StartClueSite, location: GridCenter, altMonogram: "SC")
        }
    }
    func save() {
        print("saving...")
        do {
            let data = try JSONEncoder().encode(markers)
            try data.write(to: SiteMarkersFileURL)
        } catch {
            print(error)
        }
    }
}
