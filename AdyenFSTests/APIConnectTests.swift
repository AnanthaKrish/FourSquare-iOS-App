//
//  APIConnectTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class APIConnectTests: XCTestCase {

    let mockRESessionManager = MockRESessionManager()
    var apiConnect:APIConnect!
    
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        apiConnect = APIConnect(with: mockRESessionManager)
        let clientId = "12243-423432-423423"
        let clientSecret = "qeqwr-trej4-543-fsfdds"
        let credentials = Credentials(with: clientId, clientSecret: clientSecret)
        apiConnect.setCredentials(credentials: credentials)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetURL() {
        
        guard let url = URL(string: "https://api.foursquare.com/v2/venues/explore?v=20120609&client_secret=qeqwr-trej4-543-fsfdds&client_id=12243-423432-423423") else {
            fatalError("URL can't be empty")
        }
        
        apiConnect.getRecommendations(with: [:]) { (rawRes, res, stat, error) in
        }
        XCTAssert(mockRESessionManager.lastURL?.absoluteStringByTrimmingQuery() == url.absoluteStringByTrimmingQuery())
    }
    
    func testResponseData() {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        var expectedData:RawResponse?
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "Recommendations", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
        expectedData = try? decoder.decode(RawResponse.self, from: data)
        
        mockRESessionManager.nextData = expectedData
        var actualData: RawResponse?

        apiConnect.getRecommendations(with: [:]) { (rawRes, res, stat, error) in
            
            actualData = rawRes
        }
        XCTAssertNotNil(actualData)
    }
    
    //VenueImages
    
    func testResponseImageData() {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        var expectedData:RawImageResponse?
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "VenueImages", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
        expectedData = try? decoder.decode(RawImageResponse.self, from: data)
        
        mockRESessionManager.nextImageData = expectedData
        var actualData: RawImageResponse?
        
        apiConnect.getImageUrl(from: "ijwe82khkfsd") { (rawRes, res, status, err) in
            actualData = rawRes
        }
        XCTAssertNotNil(actualData)
    }
}

extension URL {
    func absoluteStringByTrimmingQuery() -> String? {
        if var urlcomponents = URLComponents(url: self, resolvingAgainstBaseURL: false) {
            urlcomponents.query = nil
            return urlcomponents.string
        }
        return nil
    }
}
