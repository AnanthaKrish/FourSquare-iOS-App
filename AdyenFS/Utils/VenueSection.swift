//
//  VenueSection.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 03/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import UIKit

// Enum to handle the different section
enum VenueSection:Int {
    case trending = 0
    case topPicks, food, drinks, coffee, arts, outdoors, sights
    
    /**
     Return the description
     */
    func description() -> String {
        
        var description = ""
        switch self {
        case .food:
            description = "food"
        case .drinks:
            description = "drinks"
        case .coffee:
            description = "coffee"
        case .arts:
            description = "arts"
        case .outdoors:
            description = "outdoors"
        case .sights:
            description = "sights"
        case .trending:
            description = "trending"
        case .topPicks:
            description = "topPicks"
        }
        return description
    }
}
