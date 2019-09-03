//
//  UrlBuilderTests.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class UrlBuilderTests: XCTestCase {
    
   
    let clientId = "12243-423432-423423"
    let clientSecret = "qeqwr-trej4-543-fsfdds"
    var urlBuilder : UrlBuilder?
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        let credentials = Credentials(with: clientId, clientSecret: clientSecret)
        urlBuilder = UrlBuilder(credentials: credentials)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCredsUrlBuilder() {
        
        XCTAssert( clientId == urlBuilder?.credentials.clientId , "valid Credentials")
        XCTAssert( clientSecret == urlBuilder?.credentials.clientSecret , "valid Credentials")

    }
    
}
