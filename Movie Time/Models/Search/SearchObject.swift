//
//  SearchObject.swift
//  Movie Time
//
//  Created by Yury Kruk on 25.01.2022.
//

import Foundation

enum SearchObjectType: String {
    case movie, tv, person
}

enum SearchObject: Decodable {
    enum DecodingError: Error {
        case wrongJSON
    }
    
    case movie(Movie)
    case tv(TVShow)
    case person(Person)
    
    enum CodingKeys: String, CodingKey {
        case media_type = "media_type"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .media_type)
        
        switch SearchObjectType(rawValue: type) {
        case .movie:
            self = try .movie(Movie(from: decoder))
        case .tv:
            self = try .tv(TVShow(from: decoder))
        case .person:
            self = try .person(Person(from: decoder))
        default:
            throw DecodingError.wrongJSON
        }
    }
}
