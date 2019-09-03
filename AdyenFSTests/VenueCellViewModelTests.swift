//
//  VenueCellViewModelTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class VenueCellViewModelTests: XCTestCase {

    let mockRESessionManager = MockRESessionManager()
    var apiConnect:APIConnect!
    var recViewModel: RecViewModel!
    var venueCellViewModel: VenueCellViewModel!
    var credentials: Credentials!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        apiConnect = APIConnect(with: mockRESessionManager)
        let clientId = "12243-423432-423423"
        let clientSecret = "qeqwr-trej4-543-fsfdds"
        credentials = Credentials(with: clientId, clientSecret: clientSecret)
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
        
        guard let jsonUrl1 = bundle.url(forResource: "VenueImages", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data1 = try? Data(contentsOf: jsonUrl1) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
        let expectedImage = try? decoder.decode(RawImageResponse.self, from: data1)
        
        mockRESessionManager.nextImageData = expectedImage
        mockRESessionManager.nextData = expectedData
        
        recViewModel = RecViewModel(with: credentials, locationController: DummyUserLocationController(), apiRequest: apiConnect)
        venueCellViewModel = VenueCellViewModel(with: recViewModel.recomsArray.first!, credentials: credentials, apiRequest: apiConnect)

    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testData() {
        XCTAssertNotNil( venueCellViewModel.recommendations?.imageUrl, "Not nil")
    }

    func testRecommendation() {
        XCTAssertNotNil( recViewModel.recomsArray.first!.id == venueCellViewModel.recommendations?.id, "valid VenueCellViewModel")

    }
}
