//
//  VenueImage.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation

// venue image model
struct VenueImage {
    var id: String
    var url: URL?
    
    /**
     Initialize the VenueImage model
     - parameter photo: Photo object
     */
    init(photo:Photo) {
        self.id = photo.id
        self.url = URL(string: photo.itemPrefix + "300x200" + photo.suffix)
    }
}
