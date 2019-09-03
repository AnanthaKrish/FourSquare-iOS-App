//
//  RawImageResponse.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation

struct RawImageResponse:Codable {
    let meta: Meta
    let response: ImageResponse?
    
    enum CodingKeys: String, CodingKey {
        
        case meta = "meta"
        case response = "response"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        meta = try values.decode(Meta.self, forKey: .meta)
        response = try values.decodeIfPresent(ImageResponse.self, forKey: .response)
    }

}
