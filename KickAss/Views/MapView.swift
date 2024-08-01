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
    @Environment(SiteMarkerModel.self) var siteMarkerModel
    @Environment(NavigationModel.self) var navigationModel
    @Environment(CalliperModel.self) var calliperModel
    @Environment(LocationManager.self) var locationManager
    let NOT_SELECTABLE = -1
    
    var body: some View {
        @Bindable var mapModel = mapModel
        @Bindable var siteMarkerModel = siteMarkerModel
        
        MapReader { proxy in
            Map(position: $mapModel.camera, selection: $siteMarkerModel.selection) {
                UserAnnotation()
//                UserAnnotation(content:{Image(systemName: "location.fill").rotationEffect(Angle(degrees: locationManager.heading+45))})
                ForEach(gridModel.lines) {gridline in
                    MapPolyline(coordinates: gridline.points).stroke(.white, lineWidth: 1)
                }
                ForEach(gridModel.labels) {gridlabel in
                    Annotation("",coordinate: gridlabel.point) {
                        Text(gridlabel.label).foregroundStyle(.white).font(.title2)
                    }
                    .tag(NOT_SELECTABLE)
                }
                ForEach(siteMarkerModel.markers) { marker in
                    if !marker.deleted {
                        Marker("", monogram: Text(marker.monogram), coordinate: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
                            .tag(marker.id)
                            .tint(siteMarkerModel.markerColor(marker: marker))
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
                            .foregroundColor(Color.white)
                            .font(.footnote)
                    }
                    .tag(NOT_SELECTABLE)
                }
                if navigationModel.route != nil {
                    ForEach(navigationModel.steps, id: \.self) { step in
                        MapPolyline(step.polyline)
                            .stroke(.blue,lineWidth: 6)
                    }
                    if let coord = navigationModel.stepStartLocation {
                        Annotation("",coordinate: coord) {
                            Text("X")
                                .foregroundColor(.green)
                        }
                        .tag(NOT_SELECTABLE)
                    }
                    if let coord = navigationModel.stepEndLocation {
                        Annotation("",coordinate: coord) {
                            Text("X")
                                .foregroundColor(.red)
                        }
                        .tag(NOT_SELECTABLE)
                    }
                }
                if navigationModel.showTrackHistory {
                    MapPolyline(coordinates: navigationModel.trackHistoryPolyline)
                        .stroke(.green, lineWidth: 6)
                }
                if siteMarkerModel.showRangeRadius {
                    if let marker = siteMarkerModel.selection {
                        if siteMarkerModel.validMarker(markerIndex: marker){
                            if siteMarkerModel.markers[marker].type == .FoundClueSite {
                                let center = CLLocationCoordinate2D(latitude: siteMarkerModel.markers[marker].latitude, longitude: siteMarkerModel.markers[marker].longitude)
                                MapCircle(center: center, radius: siteMarkerModel.rangeRadius*METERS_PER_MILE)
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

#Preview {
    let huntInfoModel = HuntInfoModel()
    let gridModel = GridModel()
    let mapModel = MapModel()
    let siteMarkerModel = SiteMarkerModel()
    let calliperModel = CalliperModel()
    let navigationModel = NavigationModel()
    let locationManager = LocationManager()
    return MapView()
        .environment(huntInfoModel)
        .environment(gridModel)
        .environment(mapModel)
        .environment(siteMarkerModel)
        .environment(calliperModel)
        .environment(navigationModel)
        .environment(locationManager)
}
