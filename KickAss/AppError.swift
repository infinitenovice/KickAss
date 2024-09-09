//
//  AppErrors.swift
//  KickAss
//
//  Created by Infinite Novice on 9/7/24.
//

import Foundation

enum AppError: LocalizedError {
    case iCloudNotLoggedIn
    case CKSaveFailed
    case CKFetchFailed
    
    var  errorDescription: String? {
        switch self {
        case .iCloudNotLoggedIn:
            "iCloud Not Logged In"
        case .CKSaveFailed:
            "Cloud Kit Save Failed"
        case .CKFetchFailed:
            "Cloud Kit Fetch Failed"
        }
    }
    
    var failureReason: String {
        switch self {
        case .iCloudNotLoggedIn:
            ""
        case .CKSaveFailed:
            ""
        case .CKFetchFailed:
            ""
        }
    }
}
