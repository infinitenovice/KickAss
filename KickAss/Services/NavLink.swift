//
//  NavLink.swift
//  KickAss
//
//  Created by Infinite Novice on 8/31/24.
//

import SwiftUI
import CloudKit

@Observable
class NNavLink {
    
    let container = CKContainer(identifier: "iCloud.InfiniteNovice.KickAssMapLink")
    let DESTINATION_RECORD = "Destination"
    let LOCATION_FIELD = "Location"
    let SEQUENCE_FIELD = "SequenceNumber"
    
    var destinationRecord: CKRecord? = nil
    
    func connect() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: DESTINATION_RECORD, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async{
                    self.destinationRecord = record
                    print("NavLink Connected")
                }
            case .failure(let error):
                print(error)
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .success(let cursor):
                if cursor == nil {
                    // do nothing
                }
            case .failure(let error):
                print(error)
            }
        }
        container.publicCloudDatabase.add(operation)
    }
    func saveRecord(record: CKRecord) {
        container.publicCloudDatabase.save(record) { _, error in
            guard error == nil else {
                print("CloudKit Save Error: \(error!.localizedDescription)")
                return
            }
        }
    }
    func updateDestination(coordinate: CLLocationCoordinate2D) {
        if let record = destinationRecord {
            let sequenceNumber = Int(record[SEQUENCE_FIELD] ?? 0)
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            record[SEQUENCE_FIELD] = sequenceNumber + 1
            record[LOCATION_FIELD] = location
            saveRecord(record: record)
        } else {
            print("No destination record to update")
        }
    }
    
}

