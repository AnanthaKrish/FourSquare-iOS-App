//
//  VenueCellViewModel.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import CoreLocation

// Venue cell data model
class VenueCellViewModel {
            
    // MARK: varibales
    var apiRequest = APIConnect.shared
    var recommendations:Recommendations?
    
    //MARK : Methods
    
    /**
     Initialize the model
     - parameter recommendation: recommendation object
     - parameter credentials: The credentials object
     - parameter apiRequest: APIRequest object for the netowrk calls
     */
    
    init(with recommendation:Recommendations, credentials: Credentials, apiRequest: APIConnect = APIConnect.shared) {
        self.apiRequest = apiRequest
        self.apiRequest.setCredentials(credentials: credentials)
        self.recommendations = recommendation
        self.loadImageUrl()
        print("init VenueCellViewModel")
    }
    
    /**
     Load image url
     */
    func loadImageUrl() {
        
        if let id = recommendations?.id {
            apiRequest.getImageUrl(from: id) { (rawImage, res, status, error) in
                guard error == nil, let status = rawImage?.meta.code, (200...299).contains(status), let photo = rawImage?.response?.photos.items.first else {
                    print("Error while loading the image for recommendation with id \(id)")
                    return
                }
                self.recommendations?.imageUrl = self.processData(with: photo).url
            }
        }
        
    }
    
    // Process the loadImageUrl response data
    fileprivate func processData(with data:Photo) -> VenueImage {
        return VenueImage(photo: data)
    }
}
