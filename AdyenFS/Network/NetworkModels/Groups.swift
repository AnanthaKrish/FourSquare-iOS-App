//
//  Groups.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
struct Groups : Codable {
    let type : String?
    let name : String?
    let items : [Items]?
    
    enum CodingKeys: String, CodingKey {
        
        case type = "type"
        case name = "name"
        case items = "items"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        items = try values.decodeIfPresent([Items].self, forKey: .items)
    }
    
}
