//
//  LocationServiceConstants.swift
//  Bio Dash
//
//  Created by Insight Workshop on 1/28/19.
//  Copyright © 2019 Insight Workshop. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case FoundNil(String)
}

struct LocationServiceConstants {
    
    struct NotificationNames {
        static let locationCaptureError = "errorLocation"
        static let locationServiceAuthorizationStatusChange = "locationAuthorizationStatusChanged"
    }
    
    struct ErroMessages {
        static let locationCaptureError = "Could not fetch location"
        static let errorFetchingLocationSuggestion = "Could not fetch location suggestion"
    }
    
}
