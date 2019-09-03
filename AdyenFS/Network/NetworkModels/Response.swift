//
//  Response.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation
struct Response : Codable {
    let warning : Warning?
    let suggestedRadius : Int?
    let headerLocation : String?
    let headerFullLocation : String?
    let totalResults : Int?
    let groups : [Groups]?
    
    enum CodingKeys: String, CodingKey {
        
        case warning = "warning"
        case suggestedRadius = "suggestedRadius"
        case headerLocation = "headerLocation"
        case headerFullLocation = "headerFullLocation"
        case totalResults = "totalResults"
        case groups = "groups"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        warning = try values.decodeIfPresent(Warning.self, forKey: .warning)
        suggestedRadius = try values.decodeIfPresent(Int.self, forKey: .suggestedRadius)
        headerLocation = try values.decodeIfPresent(String.self, forKey: .headerLocation)
        headerFullLocation = try values.decodeIfPresent(String.self, forKey: .headerFullLocation)
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults)
        groups = try values.decodeIfPresent([Groups].self, forKey: .groups)
    }
    
}
