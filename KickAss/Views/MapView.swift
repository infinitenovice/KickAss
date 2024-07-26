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
    @Environment(CalliperModel.self) var callipers
    @Environment(NavigationModel.self) var navigation
    @Environment(LocationManager.self) var locationManager

    var body: some View {
        @Bindable var mapModel = mapModel
        @Bindable var siteMarkerModel = siteMarkerModel

        ZStack {
            MapReader { proxy in
                Map(position: $mapModel.camera, selection: $siteMarkerModel.selection) {
                    UserAnnotation()
                    ForEach(gridModel.lines) {gridline in
                        MapPolyline(coordinates: gridline.points).stroke(.white, lineWidth: 1)
                    }
                    ForEach(gridModel.labels) {gridlabel in
                        Annotation("",coordinate: gridlabel.point) {Text(gridlabel.label).foregroundStyle(.white).font(.title2)}
                    }
                    ForEach(siteMarkerModel.markers) { marker in
                        if !marker.deleted {
                            if marker.type == .ClueSite {
                                Marker("", monogram: Text(marker.monogram.rawValue), coordinate: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
                                    .tag(marker.id)
                                    .tint(siteMarkerModel.markerColor(marker: marker))
                            } else {
                                Marker("", monogram: Text(marker.altMonogram), coordinate: CLLocationCoordinate2D(latitude: marker.latitude, longitude: marker.longitude))
                                    .tag(marker.id)
                                    .tint(siteMarkerModel.markerColor(marker: marker))
                            }
                        }
                    }
                    ForEach(callipers.markers) { calliperMarker in
                        MapCircle(center: calliperMarker.center, radius: calliperMarker.radius)
                            .foregroundStyle(.clear)
                            .stroke(.blue, lineWidth: 2)
                        Annotation("",coordinate: calliperMarker.center) {Text("+")
                            .foregroundColor(Color.blue)}
                        let pointOnCircle: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: calliperMarker.center.latitude, longitude: calliperMarker.center.longitude+calliperMarker.radius*DegreesPerMeterLon)
                        MapPolyline(coordinates: [calliperMarker.center,pointOnCircle]).stroke(.blue, lineWidth: 2)
                        Annotation("",coordinate: pointOnCircle) {
                            Text(String(Int(calliperMarker.radius*FeetPerMeter))+" ft")
                                .foregroundColor(Color.white)
                                .font(.footnote)
                        }
                    }
                    if navigation.route != nil {
                        ForEach(navigation.steps, id: \.self) { step in
                            MapPolyline(step.polyline)
                                .stroke(.blue,lineWidth: 6)
                        }
                        if let coord = navigation.stepStartLocation {
                            Annotation("",coordinate: coord) {
                                Text("X")
                                    .foregroundColor(.green)
                            }
                        }
                        if let coord = navigation.stepEndLocation {
                            Annotation("",coordinate: coord) {
                                Text("X")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                }//Map
                .onAppear(){siteMarkerModel.load()}
                .mapStyle(.hybrid)
                .mapControlVisibility(.hidden)
                .onMapCameraChange { cameraContext in mapModel.camera = .region(cameraContext.region)}
                .task(id: navigation.targetDestination) {
                    if navigation.targetDestination != nil {
                        navigation.route = nil
                        await navigation.fetchRoute(locationManager: locationManager)
                    }
                }
                .onChange(of: siteMarkerModel.selection) {
                    //setting sparkle zoom to marker location when selected
                    if let markerIndex = siteMarkerModel.selection {
                        let markerLocation = CLLocationCoordinate2D(latitude: siteMarkerModel.markers[markerIndex].latitude, longitude: siteMarkerModel.markers[markerIndex].longitude)
                        mapModel.selectedSparkleZoomLocation = markerLocation
                    } else {
                        mapModel.selectedSparkleZoomLocation = nil
                    }
                }
            }//MapReader
            MapButtonsView()
            CrossHairView()
            ControlsView()
            HuntStatusView()
            if navigation.route != nil {
                NavigationView()
            }
            if let markerIndex = siteMarkerModel.selection {
                SiteDetailView(markerIndex: markerIndex)
            }
        }//ZStack
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
