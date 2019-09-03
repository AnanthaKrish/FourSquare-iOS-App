//
//  APIConnect.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import UIKit


// A class for handling the different network calls
class APIConnect {
    
    // MARK: Variables
    
    static let shared = APIConnect(with: AFSSessionmanager.shared)
    private var networkManager:NetWorkManager?
    private var urlBuilder: UrlBuilder?
    
    // MARK: Methods
    
    /**
     Initialize the APIConnect
     - parameter networkManager:  A network manager class
     */
    init(with networkManager:NetWorkManager) {
        print("init APIConnect")
        self.networkManager = networkManager
    }
    
    /**
     Set the credentials
     - parameter credentials: Credentials object
     */
    func setCredentials(credentials:Credentials) {
        self.urlBuilder = UrlBuilder(credentials: credentials)
    }
    
    /**
     Get all the recommended places
     - parameter query: A query object
     - parameter completionHandler: Completionhandler to handle the response
     */
    func getRecommendations(with query:[String:String] , completionHandler: @escaping networkFetchCompletionHandler<RawResponse>) {
        
        if let urlbuilder = self.urlBuilder {
            let url = urlbuilder.getExploreVenuesUrl(params: query)
            self.networkManager?.startNetworkAction(with: url, forType: .GET, withData: nil, withCompletionHandler: completionHandler)
        } else {
            completionHandler(nil,nil,500,.invalidUrlBuilder)
        }
    }
    
    /**
     Get teh image data front he Venue id
     - parameter id: Venue id value
     - parameter completionHandler: Completionhandler to handle the response
     */
    func getImageUrl(from id:String, completionHandler: @escaping networkFetchCompletionHandler<RawImageResponse>) {
        if let urlbuilder = self.urlBuilder {
            let url = urlbuilder.getVenuePhotoUrl(with: id)
            self.networkManager?.startNetworkAction(with: url, forType: .GET, withData: nil, withCompletionHandler: completionHandler)
        } else {
            completionHandler(nil,nil,500,.invalidUrlBuilder)
        }
    }
    
    /**
     Get image from the url
     - parameter url: image url
     - parameter completionHandler: Completionhandler to handle the response
     */
    static func getImage(for url:URL, completionHandler: @escaping ((_ image:UIImage?, _ succes:Bool?, _ error:Error?)->Void)) {
        AFSSessionmanager.image(fromURL: url, completionHandler: completionHandler)
    }
}
