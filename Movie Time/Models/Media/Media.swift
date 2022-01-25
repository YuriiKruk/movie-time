//
//  Media.swift
//  Movie Time
//
//  Created by Yury Kruk on 25.01.2022.
//

import Foundation

enum MediaType: String, Codable {
    case movie = "movie"
    case tv = "tv"
}

struct Media: Codable {
    let poster: String?
    let adult: Bool?
    let overview: String
    let releaseDate: String?
    let id: Int
    let mediaType: MediaType
    let title: String?
    let rating: Double
    let firstAirDate: String?
    let originCountry: [String]?
    let name: String?
    private let genreIds: [Int]?
    
    var genres: [String]? {
        get {
            guard let genreIds = genreIds else {
                return nil
            }
            var genres = [String]()
            genreIds.forEach { id in
                if let genre = Genres.movieGenre[id] {
                    genres.append(genre)
                }
            }
            return genres
        }
    }

    enum CodingKeys: String, CodingKey {
        case poster = "poster_path"
        case adult
        case overview
        case releaseDate = "release_date"
        case genreIds = "genre_ids"
        case id
        case mediaType = "media_type"
        case title
        case rating = "vote_average"
        case firstAirDate = "first_air_date"
        case originCountry = "origin_country"
        case name
    }
}
