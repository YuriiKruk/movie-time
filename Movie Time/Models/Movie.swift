//
//  Movie.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import Foundation

// MARK: - Movie
struct Movie: Codable {
    let adult: Bool?
    let id: Int
    let overview: String
    var posterPath: String
    let releaseDate: String
    let title: String?
    let rating: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case id
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case rating = "vote_average"
        case voteCount = "vote_count"
    }
}
