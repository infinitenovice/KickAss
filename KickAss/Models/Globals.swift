//
//  Globals.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import MapKit
// Hunt configuration
let CHECK_IN_SITE = CLLocationCoordinate2D(latitude: 33.63203, longitude: -111.88011)  //West World
let CHECK_IN_MONOGRAM = "WW" //West World
let CHECK_IN_TITLE = "West World"
let SEARCH_RADIUS = 4.0

// Grid Configuration
//let GRID_CENTER: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 34.24336, longitude: -110.08219)  // Show Low
let GRID_CENTER: CLLocationCoordinate2D = CLLocationCoordinate2D (latitude: 33.75500, longitude: -111.96700)
let GRID_REGION = MKCoordinateRegion(center: GRID_CENTER, latitudinalMeters: GRID_HEIGHT_METERS+3*METERS_PER_MILE, longitudinalMeters: GRID_WIDTH_METERS+3*METERS_PER_MILE)
let GRID_ROWS = 16
let GRID_COLUMNS = 20
let GRID_WIDTH_METERS = Measurement(value: Double(GRID_COLUMNS), unit: UnitLength.miles).converted(to: UnitLength.meters).value
let GRID_HEIGHT_METERS = Measurement(value: Double(GRID_ROWS), unit: UnitLength.miles).converted(to: UnitLength.meters).value
let CELL_WIDTH_DEGREES: CLLocationDegrees = DEGREES_PER_METER_LON*METERS_PER_MILE
let CELL_HEIGHT_DEGREES: CLLocationDegrees = DEGRESS_PER_METER_LAT*METERS_PER_MILE

// Conversions
let RADIUS_EARTH = 6378137.0 //meters
let METERS_PER_MILE = Measurement(value: 1, unit: UnitLength.miles).converted(to: UnitLength.meters).value
let MAP_INCH_TO_METERS = METERS_PER_MILE/2
let FEET_PER_METER = 3.28084
let DEGREES_PER_METER_LON = 1/((Double.pi/180)*RADIUS_EARTH*cos(GRID_CENTER.latitude*Double.pi/180))
let DEGRESS_PER_METER_LAT = 1/((Double.pi/180)*RADIUS_EARTH)

// Zoom values
let SEARCH_ZOOM_REGION = MKCoordinateSpan(latitudeDelta: SEARCH_RADIUS*2*CELL_HEIGHT_DEGREES, longitudeDelta: SEARCH_RADIUS*2*CELL_WIDTH_DEGREES)
let GRID_CELL_ZOOM = MKCoordinateSpan(latitudeDelta: 1.25*CELL_HEIGHT_DEGREES, longitudeDelta: 1.25*CELL_WIDTH_DEGREES)
let MAX_ZOOM: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)

// File Names
let SITE_MARKERS_URL = URL.documentsDirectory.appending(path: "SiteMarkers.json")
let HUNT_INFO_URL = URL.documentsDirectory.appending(path: "HuntInfo.json")
let TRACK_HISTORY_URL = URL.documentsDirectory.appending(path: "TrackHistory.json")

// Misc
let BUTTON_ERROR_SOUND = 1057 //Tink
let CALLIPER_CLEAR_CLICKS = 2
