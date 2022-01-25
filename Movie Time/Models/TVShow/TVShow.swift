//
//  TVShow.swift
//  Movie Time
//
//  Created by Yury Kruk on 23.01.2022.
//

import Foundation

struct TVShow: Codable {
    let posterPath: String?
    let popularity: Double
    let id: Int
    let rating: Double
    let overview: String
    let releaseDate: String
    let originCountry: [String]
    let originalLanguage: String
    let name: String
    private let genreIds: [Int]?
    
    var genres: [String]? {
        get {
            guard let genreIds = genreIds else {
                return nil
            }
            var genres = [String]()
            genreIds.forEach { id in
                if let genre = Genres.tvShowGenre[id] {
                    genres.append(genre)
                }
            }
            return genres
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case popularity, id
        case rating = "vote_average"
        case overview
        case releaseDate = "first_air_date"
        case originCountry = "origin_country"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case name
    }
}

