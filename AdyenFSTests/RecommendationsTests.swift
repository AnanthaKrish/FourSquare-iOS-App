//
//  RecommendationsTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class RecommendationsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testVenue() {
        
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "Recommendations", withExtension: "json") else {
            fatalError("Couldn't find resource with name Recommendations.json.")
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            fatalError("Couldn't read data for resource with name Recommendations.json.")
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let responseModel = try? decoder.decode(RawResponse.self, from: data)
        
        if let venuesArray = responseModel?.response?.groups?.first?.items {
            if venuesArray.count > 0, let item = venuesArray.first?.venue {
               let recomm = Recommendations(venue: item)
                
                XCTAssert(recomm.id == venuesArray.first?.venue?.id, "Recommendations successfully created")
            }
            
            
        } else {
            XCTFail("Failed to get response")
        }
    }
}
