//
//  Credentials.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation


/**
 The credentials for the Foursquare.
 */
public struct Credentials {
    
    // The Client ID of the Foursquare dev app
    public let clientId: String
    
    // The Client Secret ID of the Foursquare dev app
    public let clientSecret: String
    
    /**
     Initializer for the Credentials.
     - parameter clientId:    The clientId from Foursquare
     - parameter clientSecret:    The client Secret from Foursquare
     */
    init(with clientId:String, clientSecret:String) {
        
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
}
