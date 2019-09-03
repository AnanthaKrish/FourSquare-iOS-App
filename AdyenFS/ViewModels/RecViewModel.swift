//
//  RecViewModel.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import CoreLocation


enum UIResponseType {
    case Success
    case Error
    case Warning
}

// The Recommendations data handler
class RecViewModel {
    
    // MARK: Closures
    var reloadViewClosure: (()->())?
    var showAlertClosure: ((Meta?, UIResponseType, AFSError)->())?
    
    // MARK: varibales
    var apiRequest = APIConnect.shared
    var selectedSection:VenueSection = .trending
    var selectedSort:VenueSort = .sortByDistance
    
    var offset = 0
    let limit = 20
    
    var recomsArray = [Recommendations]()
    var userLocationService: UserLocation
    private var locationQuery:String = ""
    
    private var currentLocation: CLLocation? {
        didSet {
            if let location = currentLocation {
                self.locationQuery = "\(location.coordinate.latitude),\(location.coordinate.longitude)"

            } else {
                self.locationQuery = ""
            }
        }
    }
    
    //MARK : Methods
    
    /**
     Initialize the model
     - parameter credentials: The credentials object
     - parameter locationController: Object for the location manager
     - parameter apiRequest: APIRequest object for the netowrk calls
     */
    init(with credentials:Credentials, locationController:UserLocation, apiRequest: APIConnect = APIConnect.shared) {
        self.apiRequest = apiRequest
        self.apiRequest.setCredentials(credentials: credentials)
        self.userLocationService = locationController
        fetchLocation()
        print("init RecViewModel")
    }
}

extension RecViewModel {
    
    // Fetch the users current location
    fileprivate func fetchLocation() {
        self.userLocationService.requestCurrentLocation { (location, error) in
            
            guard error == nil, let location = location else {
                print("Error while fetching the location \(error?.description() ?? "")")
                return
            }
            self.currentLocation = location
            self.fetchAllRecomendations(with: self.selectedSection, offset: 0, sortBy: self.selectedSort)
        }
    }
    
    /**
     Fetch all the recomendations
     - parameter offset: Offset value for the netowrk call
     */
    public func fetchAllRecomendations(offset: Int) {
        self.fetchAllRecomendations(with: self.selectedSection, offset: offset, sortBy: self.selectedSort)
    }
    
    /**
     Fetch all the recomendations
     - parameter section: the query section for the api call
     - parameter offset: Offset value for the api call
     - parameter sortBy: sorting value for the api call
     */
    fileprivate func fetchAllRecomendations(with section:VenueSection, offset:Int, sortBy:VenueSort) {
        
        self.offset = offset
        var query = [String:String]()
        if locationQuery != "" {
            query["ll"] = locationQuery
            query["limit"] = "\(limit)"
            query["offset"] = "\(offset)"
            query["section"] = section.description()
            query[sortBy.description()] = "1"
        } else {
            print("Epmty location , \(#file)")
            self.showAlertClosure?(nil,.Error,.locationError)
            return
        }
        apiRequest.getRecommendations(with: query) { (responseModel, res, status, error) in
            
            guard error == nil, let status = responseModel?.meta?.code, (200...299).contains(status), let venuesArray = responseModel?.response?.groups?.first?.items else {
                self.recomsArray.removeAll()
                self.reloadViewClosure?()
                self.showAlertClosure?(responseModel?.meta,.Error,.invalidResponse)
                return
            }
             let recc = self.processData(items: venuesArray)

            if self.offset == 0 {
                self.recomsArray.removeAll()
                self.recomsArray = recc
            } else {
                self.recomsArray.append(contentsOf: recc)
            }
            
            self.reloadViewClosure?()
        }
    }
    
    // process the api request repsonse data
    fileprivate func processData(items: [Items]) -> [Recommendations] {

        var recm = [Recommendations]()
        if items.count > 0 {
            
            items.forEach { (item) in
                
                if let venue = item.venue {
                    let recomm = Recommendations(venue: venue)
                    recm.append(recomm)
                }
            }
        }
        return recm
    }    
}
