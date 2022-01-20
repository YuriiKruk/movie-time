//
//  MediaObject.swift
//  Movie Time
//
//  Created by Yury Kruk on 19.01.2022.
//

import Foundation

// MARK: - MediaObject
struct MediaObject: Codable {
    let results: [Media]

    enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}
