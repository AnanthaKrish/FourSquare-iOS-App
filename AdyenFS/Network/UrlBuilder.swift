//
//  UrlBuilder.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation

// url builder class - cinstruct the url for network calls
public class UrlBuilder {
    
    // MARK: Constants
    let BASE = "https://api.foursquare.com/"
    let VERSION = "/v2"
    let EXPLORE = "/venues/explore"
    let QUERYVERSION = "20120609"
    let PHOTOS = "/photos"
    let VENUES = "/venues/"
    
    // MARK: Variables
    
    // Credentials object
    var credentials: Credentials
    
    // Queries for the Url construction
    var quearies: [String:String] = [:]
    
    /**
     Initialize the UrlBuilder
     - parameter credentials:  The credentials object.
     */
    init(credentials: Credentials) {
        self.credentials = credentials
        self.quearies["client_id"] = credentials.clientId
        self.quearies["client_secret"] = credentials.clientSecret
        self.quearies["v"] = QUERYVERSION
    }
    
    /**
     Get the url for venue Recommendations.
     - parameter params:  The query parameters for the recommendations api. This is optional.
     */
    func getExploreVenuesUrl(params: [String:String]? = [:]) -> URL? {

        var queariesDic = params ?? [:]
        if !self.quearies.isEmpty {
            self.quearies.forEach { (key,value) in
                queariesDic[key] = value
            }
        }
        var urlComponents = URLComponents(string: BASE)
        urlComponents?.path = VERSION + EXPLORE
        urlComponents?.queryItems = queariesDic.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents?.url
    }
    
    /**
     get the url for venue image
     - parameter id:  Pass the venue id
     */
    func getVenuePhotoUrl(with id:String) -> URL? {
        
        var queariesDic:[String : String] = ["group":"venue","limit":"1"]
        if !self.quearies.isEmpty {
            self.quearies.forEach { (key,value) in
                queariesDic[key] = value
            }
        }
        var urlComponents = URLComponents(string: BASE)
        urlComponents?.path = VERSION + VENUES + id + PHOTOS
        urlComponents?.queryItems = queariesDic.map { URLQueryItem(name: $0.key, value: $0.value) }
        return urlComponents?.url
        
    }
}
