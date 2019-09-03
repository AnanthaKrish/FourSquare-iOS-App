//
//  Items.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
struct Items : Codable {
    let venue : Venue?
    
    enum CodingKeys: String, CodingKey {
        case venue = "venue"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        venue = try values.decodeIfPresent(Venue.self, forKey: .venue)
    }
    
}
