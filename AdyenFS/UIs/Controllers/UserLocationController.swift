//
//  UserLocationController.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
import CoreLocation

// protocol to handle the Location events
protocol UserLocation {
    
    typealias locationCompletionHandler = (_ dataObject:CLLocation?, _ error:AFSError?) -> ()
    
    func requestCurrentLocation(completionHandler: @escaping locationCompletionHandler)

}


// Class for Location management
public class UserLocationController: NSObject, CLLocationManagerDelegate, UserLocation {
   
    
    // MARK: variables
    
    // Location update handler - a delegate method
    private var locationHandler: UserLocation.locationCompletionHandler?

    // Location manager object
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        return locationManager
    }()
    
    // invokes the callbacl delegate function
    fileprivate func updateCallback(with location: CLLocation?, error: AFSError?) {
        
        guard let location = location else {
            locationHandler?(nil, error)
            return
        }
        locationHandler?(location, nil)
    }
    
    
    // Protocol method to handle the location request from the model
    func requestCurrentLocation(completionHandler: @escaping locationCompletionHandler) {
        
        locationHandler = completionHandler
        checkAccess(status: CLLocationManager.authorizationStatus(), manager: locationManager)
    }
}

// Core Location delegates
extension UserLocationController {
    
    public func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAccess(status: status, manager: manager, forLocation: true)
    }
    
    // updated the location calllback
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            updateCallback(with: location, error: nil)
        } else {
            updateCallback(with: nil, error: .locationUnKnownError)
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        updateCallback(with: nil, error: .locationError)
    }
    
    // Handle the location events
    fileprivate func checkAccess(status:CLAuthorizationStatus, manager:CLLocationManager, forLocation:Bool = false) {
        switch status {
        case .notDetermined:
            if !forLocation {
                manager.requestWhenInUseAuthorization()
            }
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .denied, .restricted:
            updateCallback(with: nil, error: .locationAuthorizationDenied)
        @unknown default:
            updateCallback(with: nil, error: .locationUnKnownError)
        }
    }
    
    
}
