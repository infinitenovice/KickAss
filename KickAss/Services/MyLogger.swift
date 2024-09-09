//
//  Logger.swift
//  KickAss
//
//  Created by Infinite Novice on 9/7/24.
//

import Foundation

@Observable
class MyLogger {
    static let shared = MyLogger()
    
    let MaxEntries = 100
    var log: [String] = []
    
    private init() {}
    
    func post(entry: String) {
        print(entry)
        if log.count >= MaxEntries {
            log.remove(at: 0)
        }
        log.append(entry)
    }
}
