//
//  Movie.swift
//  Movie Time
//
//  Created by Yury Kruk on 16.01.2022.
//

import Foundation

struct Movie: Codable {
    let adult: Bool?
    let id: Int
    let overview: String
    var posterPath: String?
    let releaseDate: String?
    let title: String
    let rating: Double
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
        case adult, id, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case rating = "vote_average"
        case genreIds = "genre_ids"
    }
}
