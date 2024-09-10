//
//  NavLinkModel.swift
//  KickAss
//
//  Created by Infinite Novice on 9/7/24.
//

import SwiftUI
import CloudKit
import OSLog


@Observable
class NavLinkModel {
    static let shared = NavLinkModel()
    var markerModel = MarkerModel.shared
    var log = Logger(subsystem: "KickAss", category: "NavLinkModel")
 
    private init() {
        self.subscribe()
        self.clear(queue: .publishQueue)
        self.clear(queue: .updateQueue)
    }
    
    let container = CKContainer(identifier: "iCloud.InfiniteNovice.KickAssMapLink")
    struct NavLinkMarker {
        var marker_id:  Int
        var location:   CLLocation
        var monogram:   String
        var status:     Bool
    }
    struct NavLinkMarkerCK {
        // Header
        static let type         = "Destination"
        static let queue        = "queue"
        static let timestamp    = "timestamp"
        // Payload
        static let marker_id    = "marker_id"
        static let location     = "location"
        static let monogram     = "monogram"
        static let status       = "status"
        

    }
    enum NavLinkQueueID: String {
        case publishQueue  = "publishQueue"
        case updateQueue   = "updateQueue"
    }
    

    func subscribe() {
        let subscription = CKQuerySubscription(recordType: NavLinkMarkerCK.type, predicate: NSPredicate(value: true), subscriptionID: "KickAssNavLink", options: [.firesOnRecordUpdate, .firesOnRecordCreation, .firesOnRecordDeletion])
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "Incomming Request"
        subscription.notificationInfo = notification
        container.publicCloudDatabase.save(subscription) { _, error in
            guard error == nil else {
                self.log.error("Subscription Error \(String(describing: error?.localizedDescription))")
                return
            }
            self.log.info("Status Updates Subscription Successful")
        }
    }
    func save(record: CKRecord) {
        container.publicCloudDatabase.save(record) { _, error in
            guard error == nil else {
                self.log.error("\(error!.localizedDescription)")
                return
            }
            self.log.info("Record Saved: \(record.recordID)")
        }
    }
    func put(marker: NavLinkMarker, queue: NavLinkQueueID) {
        let record = CKRecord(recordType: NavLinkMarkerCK.type)
        record[NavLinkMarkerCK.queue] = queue.rawValue
        record[NavLinkMarkerCK.timestamp] = Date.now
        record[NavLinkMarkerCK.location] = marker.location
        record[NavLinkMarkerCK.status] = marker.status
        record[NavLinkMarkerCK.monogram] = marker.monogram
        record[NavLinkMarkerCK.marker_id] = marker.marker_id
        self.save(record: record)
    }
    func fetchRecords(queue: NavLinkQueueID, processOnFetch: Bool, removeOnFetch: Bool) {
        var records: [CKRecord] = []
        let predicate = NSPredicate(format: "queue == %@", argumentArray: [queue.rawValue])
        let sort = NSSortDescriptor(key: NavLinkMarkerCK.timestamp, ascending: true)
        let query = CKQuery(recordType: NavLinkMarkerCK.type, predicate: predicate)
        query.sortDescriptors = [sort]
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                records.append(record)
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(_ ):
                DispatchQueue.main.async {
                    for index in 0..<records.count {
                        if processOnFetch {
                            self.processRecord(queue: queue,record: records[index])
                        }
                        if removeOnFetch {
                            self.container.publicCloudDatabase.delete(withRecordID: records[index].recordID) { _, error in
                                if let error = error {
                                    self.log.error("\(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        container.publicCloudDatabase.add(operation)
    }
    func processRecord(queue: NavLinkQueueID, record: CKRecord) {
        switch queue {
        case .publishQueue:
            log.info("Processed .publish queue record")
        case .updateQueue:
            if let markerIndex = record[NavLinkMarkerCK.marker_id] as? Int {
                markerModel.toggleFoundStatus(markerIndex: markerIndex)
                log.info("Toggle Found Status: \(markerIndex)")
            } else {
                log.error("CKRecord content invalid: marker_id")
            }
        }
    }
    func clear(queue: NavLinkQueueID) {
        fetchRecords(queue: queue, processOnFetch: false, removeOnFetch: true)
    }
    func clearAll() {
        clear(queue: .publishQueue)
        clear(queue: .updateQueue)
    }
    func publishDestination(destination: MarkerModel.SiteMarker) {
        let navLinkMarker = NavLinkModel.NavLinkMarker(
            marker_id: destination.id,
            location: CLLocation(latitude: destination.latitude, longitude: destination.longitude),
            monogram: destination.monogram,
            status: destination.found)
        put(marker: navLinkMarker, queue: .publishQueue)
    }
}
