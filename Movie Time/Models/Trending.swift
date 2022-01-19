//
//  Trending.swift
//  Movie Time
//
//  Created by Yury Kruk on 19.01.2022.
//

import Foundation

// MARK: - Trending
struct Trending: Codable {
    let results: [Movie]
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalResults = "total_results"
    }
}
