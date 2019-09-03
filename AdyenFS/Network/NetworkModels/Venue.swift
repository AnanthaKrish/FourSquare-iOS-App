//
//  Venue.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
struct Venue : Codable {
   
    let id : String
    let name : String
    let location : Location
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case name = "name"
        case location = "location"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        location = try values.decode(Location.self, forKey: .location)
    }
    
}

