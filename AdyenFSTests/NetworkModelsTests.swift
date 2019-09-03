//
//  NetworkModelsTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class NetworkModelsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testResponseData() {
        
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
        
        XCTAssert(expectedData?.meta?.code == 200, "Vaild Meta Json")
        XCTAssert(expectedData?.meta?.requestId == "5d6e4247787dba003816608b", "Vaild Meta Json")
        
        XCTAssert(expectedData?.response?.warning?.text == "There aren't a lot of results near you. Try something more general, reset your filters, or expand the search area.", "Vaild warning Json")

        XCTAssert(expectedData?.response?.groups?.first?.type == "Recommended Places", "Valid Groups")
        XCTAssert(expectedData?.response?.groups?.first?.items?.first?.venue?.id == "53d0cbeb498e76c1236f8ce9", "Valid Venue")


    }
    
    func testResponseImageData() {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "VenueImages", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
       let expectedData = try? decoder.decode(RawImageResponse.self, from: data)
      
        XCTAssert(expectedData?.meta.code == 200, "Vaild Meta Json")
        XCTAssert(expectedData?.meta.requestId == "5d6e48e8f96b2c002c9b11bc", "Vaild Meta Json")
        XCTAssert(expectedData?.response?.photos.count == 26 , "Valid response Json")
        XCTAssert(expectedData?.response?.photos.items.first!.id == "5a80197ff193c0461fc999d1" , "Valid items Json")

        
    }


}
