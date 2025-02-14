//
//  MapView.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(GridModel.self) var gridModel
    @Environment(MapModel.self) var mapModel
    @Environment(MarkerModel.self) var markerModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(CalliperModel.self) var calliperModel
    @Environment(LocationManager.self) var locationManager
    let NOT_SELECTABLE = -1
    
    var body: some View {
        @Bindable var mapModel = mapModel
        @Bindable var markerModel = markerModel
        
        MapReader { proxy in
            Map(position: $mapModel.camera,  interactionModes:[.pan,.zoom], selection: $markerModel.selection) {
                UserAnnotation()
                ForEach(gridModel.lines) {gridline in
                    MapPolyline(coordinates: gridline.points).stroke(.white, lineWidth: 1)
                }
                ForEach(gridModel.labels) {gridlabel in
                    Annotation("",coordinate: gridlabel.point) {
                        Text(gridlabel.label).foregroundStyle(Color.theme.textPrimary).font(.title2)
                    }
                    .tag(NOT_SELECTABLE)
                }
                ForEach(markerModel.data.markers) { marker in
                    if !marker.deleted {
                        Marker(marker.title, monogram: Text(marker.monogram), coordinate: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
                            .tag(marker.id)
                            .tint(markerModel.markerColor(marker: marker))
                    }
                }
                ForEach(calliperModel.markers) { calliperMarker in
                    MapCircle(center: calliperMarker.center, radius: calliperMarker.radius)
                        .foregroundStyle(.clear)
                        .stroke(.blue, lineWidth: 2)
                    Annotation("",coordinate: calliperMarker.center) {
                        Text("+")
                            .foregroundColor(Color.blue)
                    }
                    .tag(NOT_SELECTABLE)
                    let pointOnCircle: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: calliperMarker.center.latitude, longitude: calliperMarker.center.longitude+calliperMarker.radius*DEGREES_PER_METER_LON)
                    MapPolyline(coordinates: [calliperMarker.center,pointOnCircle]).stroke(.blue, lineWidth: 2)
                    Annotation("",coordinate: pointOnCircle) {
                        Text(String(Int(calliperMarker.radius*FEET_PER_METER))+" ft")
                            .foregroundColor(Color.theme.textPrimary)
                            .font(.footnote)
                    }
                    .tag(NOT_SELECTABLE)
                }
                ForEach(navigationModel.steps, id: \.self) { step in
                    MapPolyline(step.polyline)
                        .stroke(.blue,lineWidth: 6)
                }
                if navigationModel.showTrackHistory {
                    MapPolyline(coordinates: navigationModel.trackHistoryPolyline)
                        .stroke(.green, lineWidth: 6)
                }
                if markerModel.showRangeRadius {
                    if let marker = markerModel.selection {
                        if markerModel.validMarker(markerIndex: marker){
                            if markerModel.data.markers[marker].found {
                                let center = CLLocationCoordinate2D(latitude: markerModel.data.markers[marker].latitude, longitude: markerModel.data.markers[marker].longitude)
                                MapCircle(center: center, radius: markerModel.rangeRadius*METERS_PER_MILE)
                                    .foregroundStyle(.blue.opacity(0.2))
                            }
                        }
                    }
                }
            }//Map
            .mapStyle(.hybrid)
            .mapControlVisibility(.hidden)
            .onMapCameraChange { cameraContext in mapModel.camera = .region(cameraContext.region)}
        }//MapReader
    }//body
}//MapView

