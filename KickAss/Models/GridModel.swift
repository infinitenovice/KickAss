//
//  GridModel.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import MapKit




@Observable
class GridModel {
    var lines: [GridLine] = []
    var labels: [GridLabel] = []

    
    let boundaryNorth = GRID_CENTER.latitude + GRID_HEIGHT_METERS*DEGRESS_PER_METER_LAT/2
    let boundarySouth = GRID_CENTER.latitude - GRID_HEIGHT_METERS*DEGRESS_PER_METER_LAT/2
    let boundaryEast = GRID_CENTER.longitude + GRID_WIDTH_METERS*DEGREES_PER_METER_LON/2
    let boundaryWest = GRID_CENTER.longitude - GRID_WIDTH_METERS*DEGREES_PER_METER_LON/2
    
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
        for column in (0...GRID_COLUMNS) {
            p1.longitude = boundaryWest + Double(column) * CELL_WIDTH_DEGREES
            p2.longitude = boundaryWest + Double(column) * CELL_WIDTH_DEGREES
            appendGridLine(id: column, p1: p1, p2: p2)
        }
        
        p1.longitude = boundaryEast
        p2.longitude = boundaryWest
        for row in (0...GRID_ROWS) {
            p1.latitude = boundaryNorth - Double(row) * CELL_HEIGHT_DEGREES
            p2.latitude = boundaryNorth - Double(row) * CELL_HEIGHT_DEGREES
            appendGridLine(id: (GRID_COLUMNS+1)+row, p1: p1, p2: p2)
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

        p1.latitude = boundaryNorth + CELL_HEIGHT_DEGREES/2
        p2.latitude = boundarySouth - CELL_HEIGHT_DEGREES/2
        for column in (0..<GRID_COLUMNS) {
            p1.longitude = boundaryWest + (Double(column) * CELL_WIDTH_DEGREES) + CELL_WIDTH_DEGREES/2
            p2.longitude = boundaryWest + (Double(column) * CELL_WIDTH_DEGREES) + CELL_WIDTH_DEGREES/2
            appendGridLabel(id: column, point: p1, label: String(UnicodeScalar(column + 65)!))
            appendGridLabel(id: column+GRID_COLUMNS, point: p2, label: String(UnicodeScalar(column + 65)!))
        }
        
        p1.longitude = boundaryEast + CELL_WIDTH_DEGREES/2
        p2.longitude = boundaryWest - CELL_WIDTH_DEGREES/2
        for row in (0..<GRID_ROWS) {
            p1.latitude = boundaryNorth - (Double(row) * CELL_HEIGHT_DEGREES) - CELL_HEIGHT_DEGREES/2
            p2.latitude = boundaryNorth - (Double(row) * CELL_HEIGHT_DEGREES) - CELL_HEIGHT_DEGREES/2
            appendGridLabel(id: row+(GRID_COLUMNS*2), point: p1, label: String(row+1))
            appendGridLabel(id: row+GRID_ROWS+(GRID_COLUMNS*2), point: p2, label: String(row+1))
        }
        
        func appendGridLabel(id: Int, point: CLLocationCoordinate2D, label: String) {
            gridLabel.id = id
            gridLabel.point = point
            gridLabel.label = label
            gridLabels.append(gridLabel)
        }
        return gridLabels
        
    }
    
    func onGrid(point: CLLocationCoordinate2D) -> Bool {
        return (point.latitude <= boundaryNorth && point.latitude >= boundarySouth && point.longitude <= boundaryEast && point.longitude >= boundaryWest)
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
