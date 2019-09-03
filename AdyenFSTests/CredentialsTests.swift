//
//  CredentialsTest.swift
//  AdyenFSTests
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import XCTest
@testable import AdyenFS

class CredentialsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreds() {
        let clientId = "12243-423432-423423"
        let clientSecret = "qeqwr-trej4-543-fsfdds"
        let credentials = Credentials(with: clientId, clientSecret: clientSecret)
        
        XCTAssert( clientId == credentials.clientId , "valid Credentials")
        XCTAssert( clientSecret == credentials.clientSecret , "valid Credentials")
    }


}
