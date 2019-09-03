//
//  VenueImageTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class VenueImageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImage() {
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let bundle = Bundle(for: type(of: self))
        guard let jsonUrl = bundle.url(forResource: "VenueImages", withExtension: "json") else {
            XCTFail("Couldn't find resource with name Recommendations.json.")
            return
        }
        
        guard let data = try? Data(contentsOf: jsonUrl) else {
            XCTFail("Couldn't read data for resource with name Recommendations.json.")
            return
        }
        
        let imageResponse = try? decoder.decode(RawImageResponse.self, from: data)
        
        if let photo = imageResponse?.response?.photos.items.first {
            let image = VenueImage(photo: photo)
            
            XCTAssert(photo.id == image.id, "VenueImage created successfully")
        } else {
            XCTFail()
        }
        
       
        
    }
   

}
