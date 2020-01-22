//
//  Content.swift
//  NetflixRoulette
//
//  Created by Daniel Plata on 22/01/2020.
//  Copyright © 2020 silverapps. All rights reserved.
//

import Foundation

struct ContentResponse: Decodable {
    let id: String
    let title: String
    let overview: String
    let classification: String?
    let releasedOn: String
    let contentType: String
    let hasPoster: Bool

    enum CodingKeys: String, CodingKey {
        case title, overview, classification, id
        case releasedOn = "released_on"
        case contentType = "content_type"
        case hasPoster = "has_poster"
    }
}
