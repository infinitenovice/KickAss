//
//  GridModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import MapKit

let GridCenter: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 34.24336, longitude: -110.08219)  // Show Low
//let GridCenter: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 33.75500, longitude: -111.96700)
let GridRegion = MKCoordinateRegion(center: GridCenter, latitudinalMeters: GridHeightMeters+3*MetersPerMile, longitudinalMeters: GridWidthMeters+3*MetersPerMile)
let GridRows = 16
let GridColumns = 20
let GridWidthMeters = Measurement(value: Double(GridColumns), unit: UnitLength.miles).converted(to: UnitLength.meters).value
let GridHeightMeters = Measurement(value: Double(GridRows), unit: UnitLength.miles).converted(to: UnitLength.meters).value

let RadiusEarth = 6378137.0 //meters
let MetersPerMile = Measurement(value: 1, unit: UnitLength.miles).converted(to: UnitLength.meters).value
let MapInchToMeters = MetersPerMile/2
let FeetPerMeter = 3.28084
let DegreesPerMeterLon = 1/((Double.pi/180)*RadiusEarth*cos(GridCenter.latitude*Double.pi/180))
let DegreesPerMeterLat = 1/((Double.pi/180)*RadiusEarth)
let GridCellWidthDegrees: CLLocationDegrees = DegreesPerMeterLon*MetersPerMile
let GridCellHeightDegrees: CLLocationDegrees = DegreesPerMeterLat*MetersPerMile


@Observable
class GridModel {
    var lines: [GridLine] = []
    var labels: [GridLabel] = []

    
    let boundaryNorth = GridCenter.latitude + GridHeightMeters*DegreesPerMeterLat/2
    let boundarySouth = GridCenter.latitude - GridHeightMeters*DegreesPerMeterLat/2
    let boundaryEast = GridCenter.longitude + GridWidthMeters*DegreesPerMeterLon/2
    let boundaryWest = GridCenter.longitude - GridWidthMeters*DegreesPerMeterLon/2
    
    init() {
        lines = initializeGridLines()
        labels = initializeGridLabels()
    }
    
    func initializeGridLines() -> [GridLine] {
        var gridLines: [GridLine] = []
        var gridLine: GridLine = GridLine(points: [])
        var p1: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var p2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        
        p1.latitude = boundaryNorth
        p2.latitude = boundarySouth
        for column in (0...GridColumns) {
            p1.longitude = boundaryWest + Double(column) * GridCellWidthDegrees
            p2.longitude = boundaryWest + Double(column) * GridCellWidthDegrees
            appendGridLine(id: column, p1: p1, p2: p2)
        }
        
        p1.longitude = boundaryEast
        p2.longitude = boundaryWest
        for row in (0...GridRows) {
            p1.latitude = boundaryNorth - Double(row) * GridCellHeightDegrees
            p2.latitude = boundaryNorth - Double(row) * GridCellHeightDegrees
            appendGridLine(id: (GridColumns+1)+row, p1: p1, p2: p2)
        }
        
        func appendGridLine(id: Int, p1: CLLocationCoordinate2D, p2: CLLocationCoordinate2D) {
            gridLine.id = id
            gridLine.points.append(p1)
            gridLine.points.append(p2)
            gridLines.append(gridLine)
            gridLine.points.removeAll()
        }
        return gridLines
    }//initializeGridLines
    
    func initializeGridLabels () -> [GridLabel] {
        var gridLabels: [GridLabel] = []
        var gridLabel: GridLabel = GridLabel(id: 0, label: "", point: CLLocationCoordinate2D(latitude: 0, longitude: 0))
        var p1: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
        var p2: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)

        p1.latitude = boundaryNorth + GridCellHeightDegrees/2
        p2.latitude = boundarySouth - GridCellHeightDegrees/2
        for column in (0..<GridColumns) {
            p1.longitude = boundaryWest + (Double(column) * GridCellWidthDegrees) + GridCellWidthDegrees/2
            p2.longitude = boundaryWest + (Double(column) * GridCellWidthDegrees) + GridCellWidthDegrees/2
            appendGridLabel(id: column, point: p1, label: String(UnicodeScalar(column + 65)!))
            appendGridLabel(id: column+GridColumns, point: p2, label: String(UnicodeScalar(column + 65)!))
        }
        
        p1.longitude = boundaryEast + GridCellWidthDegrees/2
        p2.longitude = boundaryWest - GridCellWidthDegrees/2
        for row in (0..<GridRows) {
            p1.latitude = boundaryNorth - (Double(row) * GridCellHeightDegrees) - GridCellHeightDegrees/2
            p2.latitude = boundaryNorth - (Double(row) * GridCellHeightDegrees) - GridCellHeightDegrees/2
            appendGridLabel(id: row+(GridColumns*2), point: p1, label: String(row+1))
            appendGridLabel(id: row+GridRows+(GridColumns*2), point: p2, label: String(row+1))
        }
        
        func appendGridLabel(id: Int, point: CLLocationCoordinate2D, label: String) {
            gridLabel.id = id
            gridLabel.point = point
            gridLabel.label = label
            gridLabels.append(gridLabel)
        }
        return gridLabels
    }
    
    struct GridLine: Identifiable {
        var id: Int = 0
        var points: [CLLocationCoordinate2D] = []
    }
    
    struct GridLabel: Identifiable {
        var id: Int
        var label: String
        var point: CLLocationCoordinate2D
    }
}
