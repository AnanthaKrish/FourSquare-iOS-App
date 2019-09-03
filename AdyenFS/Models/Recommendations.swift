//
//  Recommendations.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import MapKit

// Recommendations model
struct Recommendations: Hashable {
    
    var id: String
    var name: String
    var address:String
    var crossStreet: String
    var latitude:String
    var longitude:String
    var distance: String
    var imageUrl: URL?
    
    /**
     Initialize the Recommendations model
     - parameter venue: venue object
     */
    init(venue:Venue) {
        
        self.id = venue.id
        self.name = venue.name
        self.address = venue.location.address ?? ""
        self.crossStreet = venue.location.crossStreet ?? ""
        self.latitude = ""
        self.longitude = ""
        self.distance = ""
        
        if let latitude = venue.location.lat {
            self.latitude = "\(latitude)"
        }
        if let longitude = venue.location.lng {
            self.longitude = "\(longitude)"
        }
        if let distance = venue.location.distance {
            let distanceFormatter = MKDistanceFormatter()
            let formattedDistance = distanceFormatter.string(fromDistance: distance)
            self.distance = formattedDistance
        }
    }
}
