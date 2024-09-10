//
//  LocationExtensions.swift
//  KickAss
//
//  Created by Infinite Novice on 9/9/24.
//

import Foundation
import CoreLocation

public extension CLLocationCoordinate2D {
    func distance(from: CLLocationCoordinate2D) -> CLLocationDistance {
        let destination=CLLocation(latitude:from.latitude,longitude:from.longitude)
        return CLLocation(latitude: latitude, longitude: longitude).distance(from: destination)
    }
}
