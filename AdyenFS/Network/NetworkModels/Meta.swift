//
//  meta.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
struct Meta : Codable {
    let code : Int?
    let requestId : String?
    let errorDetail: String?
    let errorType: String?
    
    enum CodingKeys: String, CodingKey {
        
        case code = "code"
        case requestId = "requestId"
        case errorDetail = "errorDetail"
        case errorType = "errorType"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        code = try values.decodeIfPresent(Int.self, forKey: .code)
        requestId = try values.decodeIfPresent(String.self, forKey: .requestId)
        errorType = try values.decodeIfPresent(String.self, forKey: .errorType)
        errorDetail = try values.decodeIfPresent(String.self, forKey: .errorDetail)
    }
    
}
