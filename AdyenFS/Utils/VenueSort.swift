//
//  VenueSort.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 03/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Enum for the sorting
enum VenueSort:Int {
    
    case openNow = 0
    case sortByDistance
    
    /**
     Return the description
     */
    func description() -> String {
        
        var description = ""
        switch self {
        case .openNow:
            description = "openNow"
        case .sortByDistance:
            description = "sortByDistance"
        }
        return description
    }
    
}
