//
//  NavLinkModel.swift
//  KickAss
//
//  Created by Infinite Novice on 9/7/24.
//

import CloudKit
import OSLog


@Observable
class NavLinkModel {
    static let shared = NavLinkModel()
    var log = Logger(subsystem: "KickAss", category: "NavLinkPublisherModel")
  
    let container = CKContainer(identifier: "iCloud.InfiniteNovice.KickAssMapLink")
    struct DestinationRecord {
        static let type = "Destination"
        struct fields {
            static let location     = "Location"
            static let timestamp    = "TimeStamp"
            static let found        = "Found"
            static let monogram     = "Monogram"
            static let marker_id    = "ID"
        }
    }
    struct StatusUpdateRecord {
        static let type = "StatusUpdate"
        struct fields {
            static let marker_id    = "ID"
            static let found        = "Found"
        }
    }
    private init() {
        self.clearDestination()
        self.clearStatusUpates()
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
    
    func publishDestination(destination: MarkerModel.SiteMarker) {
        let record = CKRecord(recordType: DestinationRecord.type)
        let location = CLLocation(latitude: destination.latitude, longitude: destination.latitude)
        record[DestinationRecord.fields.location] = location
        record[DestinationRecord.fields.timestamp] = Date.now
        record[DestinationRecord.fields.found] = destination.found
        record[DestinationRecord.fields.monogram] = destination.monogram
        record[DestinationRecord.fields.marker_id] = destination.id
        self.save(record: record)
    }
    func clearDestination() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DestinationRecord.type, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async {
                    self.container.publicCloudDatabase.delete(withRecordID: record.recordID) { id, error in
                        if let error = error {
                            self.log.error("\(error.localizedDescription)")
                        } else {
                            self.log.info("Deleted Destination Record: \(id)")
                        }
                    }
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(_ ):
                DispatchQueue.main.async {
                    self.log.info("Cleared all Destination records")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.log.error("\(error.localizedDescription)")
                }
            }
        }
        container.publicCloudDatabase.add(operation)
    }
    func clearStatusUpates() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: StatusUpdateRecord.type, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async {
                    self.container.publicCloudDatabase.delete(withRecordID: record.recordID) { id, error in
                        if let error = error {
                            self.log.error("\(error.localizedDescription)")
                        } else {
                            self.log.info("Deleted Status Update Record: \(id)")
                        }
                    }
                }
            case .failure(let error):
                self.log.error("\(error.localizedDescription)")
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(_ ):
                DispatchQueue.main.async {
                    self.log.info("Cleared all Status Update records")
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self.log.error("\(error.localizedDescription)")
                }
            }
        }
        container.publicCloudDatabase.add(operation)
    }
    func fetchStatusUpdates() {
        log.info("Fetching Status Updates - STUB")
    }
}
