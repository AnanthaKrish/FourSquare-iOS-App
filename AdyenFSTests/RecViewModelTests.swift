//
//  RecViewModelTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
import CoreLocation

@testable import AdyenFS

class RecViewModelTests: XCTestCase {

    let mockRESessionManager = MockRESessionManager()
    var apiConnect:APIConnect!
    var recViewModel: RecViewModel!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        apiConnect = APIConnect(with: mockRESessionManager)
        let clientId = "12243-423432-423423"
        let clientSecret = "qeqwr-trej4-543-fsfdds"
        let credentials = Credentials(with: clientId, clientSecret: clientSecret)
        apiConnect.setCredentials(credentials: credentials)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "Recommendations", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
        let expectedData = try? decoder.decode(RawResponse.self, from: data)
        
        mockRESessionManager.nextData = expectedData
        
        recViewModel = RecViewModel(with: credentials, locationController: DummyUserLocationController(), apiRequest: apiConnect)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testData() {
        
        XCTAssert(recViewModel.recomsArray.count > 0, "RecViewModel is valid")
    }
    
    func testFilter() {
        
        recViewModel.selectedSort = .openNow
        recViewModel.selectedSection = .drinks
        recViewModel.offset = 50
        
        XCTAssert(recViewModel.selectedSection == .drinks, "RecViewModel is valid")
        XCTAssert(recViewModel.selectedSort == .openNow, "RecViewModel is valid")
        XCTAssert(recViewModel.offset == 50, "RecViewModel is valid")

    }
    

}

public class DummyUserLocationController: NSObject, UserLocation {
    
    private var locationHandler: UserLocation.locationCompletionHandler?

    public func requestCurrentLocation(completionHandler: @escaping UserLocation.locationCompletionHandler) {
        let myLocation = CLLocation(latitude: 12.344, longitude: -90.434)
        completionHandler(myLocation, nil)
    }
}
