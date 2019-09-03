//
//  ImageResponse.swift
//  AdyenFS
//
//  Created by Anantha Krishnan K G on 01/09/19.
//  Copyright © 2019 Ananth. All rights reserved.
//

import Foundation

struct ImageResponse:Codable {
    let photos: Photos
    enum CodingKeys: String, CodingKey {
        case photos = "photos"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        photos = try values.decode(Photos.self, forKey: .photos)
    }
}

struct Photos: Codable {
    let count: Int
    let items: [Photo]
    enum CodingKeys: String, CodingKey {
        case count
        case items = "items"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        count = try values.decode(Int.self, forKey: .count)
        items = try values.decode([Photo].self, forKey: .items)

    }
}

struct Photo: Codable {
    let id: String
    let createdAt: Int
    let itemPrefix: String
    let suffix: String
    let width, height: Int
    
    enum CodingKeys: String, CodingKey {
        case id, createdAt
        case itemPrefix = "prefix"
        case suffix, width, height
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(String.self, forKey: .id)
        createdAt = try values.decode(Int.self, forKey: .createdAt)
        itemPrefix = try values.decode(String.self, forKey: .itemPrefix)
        suffix = try values.decode(String.self, forKey: .suffix)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
    }
}
