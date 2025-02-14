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
 
    let container = CKContainer(identifier: "iCloud.InfiniteNovice.KickAssMapLink")
    var currentPosting: CKRecord
    
    struct DestinationRecord {
        // Header
        static let type         = "Destination"
        static let timestamp    = "timestamp"
        // Payload
        static let monogram     = "monogram"
        static let location     = "location"
        static let status       = "status"
    }
    struct FoundNotice {
        static let type         = "FoundNotice"
        static let timestamp    = "timestamp"
        static let monogram     = "monogram"
    }
    private init() {
        self.currentPosting = CKRecord(recordType: DestinationRecord.type)
        self.subscribe()
        self.reset()
        self.clearFoundNotices()
    }
    func subscribe() {
        let subscription = CKQuerySubscription(recordType: FoundNotice.type, predicate: NSPredicate(value: true), subscriptionID: "NavLinkFoundNotices", options: [.firesOnRecordCreation])
        let notification = CKSubscription.NotificationInfo()
        notification.alertBody = "Found Notice"
        notification.desiredKeys = [FoundNotice.monogram]
        subscription.notificationInfo = notification
        container.publicCloudDatabase.save(subscription) { _, error in
            guard error == nil else {
                self.log.error("Subscription Error \(String(describing: error?.localizedDescription))")
                return
            }
            self.log.info("Status Updates Subscription Successful")
        }
    }
    func postSite(site: MarkerModel.SiteMarker) {
        self.container.publicCloudDatabase.fetch(withRecordID: currentPosting.recordID) { record, error in
            guard error == nil else {
                self.log.error("\(error!.localizedDescription)")
                return
            }
            if let record = record {
                self.log.info("Fetched: \(self.currentPosting.recordID)")
                record[DestinationRecord.timestamp] = Date.now
                record[DestinationRecord.location] = CLLocation(latitude: site.latitude, longitude: site.longitude)
                record[DestinationRecord.status] = site.found
                record[DestinationRecord.monogram] = site.monogram
                self.container.publicCloudDatabase.save(record) { _, error in
                    guard error == nil else {
                        self.log.error("postSite:\(error!.localizedDescription)")
                        return
                    }
                    self.currentPosting = record
                    self.log.info("Posted: \(record.recordID)")
                }
            }
        }
    }
    func removePosting() {
        self.container.publicCloudDatabase.fetch(withRecordID: currentPosting.recordID) { record, error in
            guard error == nil else {
                self.log.error("\(error!.localizedDescription)")
                return
            }
            if let record = record {
                record[DestinationRecord.monogram] = "nil"
                record[DestinationRecord.timestamp] = Date.now
                record[DestinationRecord.location] = CLLocation(latitude: 0.0, longitude: 0.0)
                record[DestinationRecord.status] = false
                self.container.publicCloudDatabase.save(record) { _, error in
                    guard error == nil else {
                        self.log.error("\(error!.localizedDescription)")
                        return
                    }
                    self.currentPosting = record
                    self.log.info("Posting Removed \(self.currentPosting.recordID)")
                }
            }
        }
    }
    func reset() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DestinationRecord.type, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                self.container.publicCloudDatabase.delete(withRecordID: record.recordID) { _, error in
                    if let error = error {
                        self.log.error("\(error.localizedDescription)")
                    } else {
                        self.log.info("Record Deleted \(record.recordID)")
                    }
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(_ ):
                self.currentPosting[DestinationRecord.monogram] = "nil"
                self.currentPosting[DestinationRecord.timestamp] = Date.now
                self.currentPosting[DestinationRecord.location] = CLLocation(latitude: 0.0, longitude: 0.0)
                self.currentPosting[DestinationRecord.status] = false
                self.container.publicCloudDatabase.save(self.currentPosting) { _, error in
                    guard error == nil else {
                        self.log.error("\(error!.localizedDescription)")
                        return
                    }
                    self.log.info("Posted nil record: \(self.currentPosting.recordID)")
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        container.publicCloudDatabase.add(operation)
    }

    func clearFoundNotices() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: FoundNotice.type, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                    self.container.publicCloudDatabase.delete(withRecordID: record.recordID) { _, error in
                    if let error = error {
                        self.log.error("\(error.localizedDescription)")
                    } else {
                        self.log.info("Record Deleted \(record.recordID)")
                    }
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(_ ):
                self.log.info("Cleared all found notices")
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        container.publicCloudDatabase.add(operation)
    }
    func processNotification(notification: UNNotification) {
        if notification.request.content.body == "Found Notice" {
            if let dict = notification.request.content.userInfo as? [String: Any] {
                if let ck = dict["ck"] as? [String: Any] {
                    if let qry = ck["qry"] as? [String: Any] {
                        if let af = qry["af"] as? [String: String] {
                            if let monogram = af["monogram"] {
                                log.info("Found Notice: \(monogram)")
                                DispatchQueue.main.async {
                                    self.markerModel.setClueSiteFound(monogram: monogram)
                                }
                            }
                        }
                        if let rid = qry["rid"] as? String {
                            let recordID = CKRecord.ID(recordName: rid)
                            self.container.publicCloudDatabase.delete(withRecordID: recordID) { _, error in
                                if let error = error {
                                    self.log.error("\(error.localizedDescription)")
                                } else {
                                    self.log.info("Found Notice Record Deleted \(recordID)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
