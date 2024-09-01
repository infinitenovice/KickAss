//
//  CloudKitModel.swift
//  KickAss
//
//  Created by Infinite Novice on 8/31/24.
//

import CloudKit

@Observable
class CloudKitModel {

    var destinationRecord: CKRecord? = nil
    
    let container = CKContainer(identifier: "iCloud.InfiniteNovice.KickAssMapLink")
    let RECORD_TYPE = "Destination"
    let LOCATION_FIELD = "Location"
    let TIMESTAMP_FIELD = "Timestamp"
    let DEFAULT_LOCATION = CLLocation(latitude: 33.63203, longitude: -111.88011)  //West World

    init() {
        fetch()
    }
    
    func fetch() {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RECORD_TYPE, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.recordMatchedBlock = { id, result in
            switch result {
            case .success(let record):
                DispatchQueue.main.async{
                    self.destinationRecord = record
                }
            case .failure(let error):
                self.setErrorMessage(message: error.localizedDescription)
            }
        }
        operation.queryResultBlock = { result in
            switch result {
            case .failure(let error):
                self.setErrorMessage(message: error.localizedDescription)
            default:
                DispatchQueue.main.async{
                    self.setStatusMessage(message: "Fetch Complete")
                }
            }
        }
        setStatusMessage(message: "Fetching")
        container.publicCloudDatabase.add(operation)
    }
    
    func save(record: CKRecord) {
        container.publicCloudDatabase.save(record) { _, error in
            guard error == nil else {
                self.setErrorMessage(message: "CloudKit \(error!.localizedDescription)")
                return
            }
            self.setStatusMessage(message: "Record Saved")
        }
    }
    
    func update(coordinate: CLLocationCoordinate2D) {
        if let record = destinationRecord {
            let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            record[TIMESTAMP_FIELD] = Date.now
            record[LOCATION_FIELD] = location
            save(record: record)
        } else {
            setErrorMessage(message: "No destination record to update")
        }
    }
    func newRecord() {
        let record = CKRecord(recordType: RECORD_TYPE)
        record[LOCATION_FIELD] = DEFAULT_LOCATION
        record[TIMESTAMP_FIELD] = Date.now
        save(record: record)
    }
    
    func setStatusMessage(message: String) {
        DispatchQueue.main.async {
            print(message)
        }
    }
    func setErrorMessage(message: String) {
        DispatchQueue.main.async {
            print(message)
        }
    }
}
