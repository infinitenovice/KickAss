//
//  KickAssApp.swift
//  KickAss
//
//  Created by Infinite Novice on 7/24/24.
//

/*
 Todo:
 Implement publish and clear for destination sharing accross devices
 - test navlink toggle on all scenarios
 Publish nav link to test flight
 Add auto-drop to navlink app instead of post/airdrop shortcut
 
 Check route functionality, remove my step processing if possible
 Refactor environment with container class
 Refactor globals to config class
 Refactor to not have to pass marker selection as parameter
 Refactor persistent data (JSON save data) into top level class
 font extensions
 change NOTSELECTABLE to nil for tags
 */
import SwiftUI
import OSLog

@main
struct KickAssApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @State private var gridModel        = GridModel()
    @State private var mapModel         = MapModel()
    @State private var calliperModel    = CalliperModel()
    @State private var locationManager  = LocationManager()
    @State private var huntInfoModel    = HuntInfoModel()
    @State private var statisticsModel  = StatisticsModel()
    @State private var navigationModel  = NavigationModel.shared
    @State private var timerModel       = TimerModel.shared
    @State private var markerModel      = MarkerModel.shared
    @State private var navLinkModel     = NavLinkModel.shared

    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                ContentView()
            } else {
                LocationDeniedView()
            }
        }
        .environment(gridModel)
        .environment(mapModel)
        .environment(calliperModel)
        .environment(locationManager)
        .environment(huntInfoModel)
        .environment(statisticsModel)
        .environment(navigationModel)
        .environment(timerModel)
        .environment(markerModel)
        .environment(navLinkModel)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var navLinkModel = NavLinkModel.shared
    
    var log = Logger(subsystem: "KickAss", category: "AppDelegate")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: .alert) { granted, error in
            if let error = error {
                self.log.error("User notifications error: \(error.localizedDescription)")
            } else {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    self.log.info("Registered for remote notifications")
                }
            }
        }
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge])
        self.log.info("Foreground notification")
        navLinkModel.fetchRecords(queue: .updateQueue, processOnFetch: true, removeOnFetch: true)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        self.log.info( "Background notification")
        navLinkModel.fetchRecords(queue: .updateQueue, processOnFetch: true, removeOnFetch: true)
    }
}
