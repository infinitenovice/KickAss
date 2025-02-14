//
//  MapKitExtensions.swift
//  KickAss
//
//  Created by Infinite Novice on 9/9/24.
//

import Foundation
import MapKit

public extension MKMultiPoint {
    var coordinates: [CLLocationCoordinate2D] {
        var coords = [CLLocationCoordinate2D](repeating: kCLLocationCoordinate2DInvalid,
                                              count: pointCount)
        getCoordinates(&coords, range: NSRange(location: 0, length: pointCount))
        return coords
    }
}
