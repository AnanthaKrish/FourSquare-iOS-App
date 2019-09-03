//
//  AFSError.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation


/**
 Custom error cases
 */
public enum AFSError:Error {
    
    // Url is invalid or not able to construct a proper url.
    case invalidUrl
    
    // No data from the server
    case noData
    
    // Response parsong error
    case jsonError
    
    // empty response
    case emptyResponse
    
    // Invalid response
    case invalidResponse
    
    // Invalid url builder error
    case invalidUrlBuilder
    
    // Location access denied
    case locationAuthorizationDenied
    
    // Location unKnown error
    case locationUnKnownError
    
    // Location error
    case locationError
    
    
    func description() -> String {
        var description = ERROR_UNEXPECTED
        switch self {
        case .invalidUrl:
            description = ERROR_INVALID_URL
        case .noData:
            description = ERROR_NO_DATA
        case .jsonError:
            description = ERROR_JSON_PARSE
        case .emptyResponse:
            description = ERROR_EMPTY_RESPONSE
        case .invalidResponse:
            description = ERROR_INVALID_RESPONSE
        case .invalidUrlBuilder:
            description = ERROR_INVALID_URLBUILDER
        case .locationAuthorizationDenied:
            description = ERROR_LOCATION_DENIED
        case .locationUnKnownError:
            description = ERROR_LOCATION_UNKNOWN
        case .locationError:
            description = ERROR_LOCATION
        }
        return description
    }
    
}


struct RuntimeError: Error {
    let message: String
    
    init(_ message: String) {
        self.message = message
    }
    
    public var localizedDescription: String {
        return message
    }
}
