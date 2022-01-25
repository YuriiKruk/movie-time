//
//  SearchResult.swift
//  Movie Time
//
//  Created by Yury Kruk on 25.01.2022.
//

import Foundation

enum SearchResult {
    case movie(models: Movie)
    case tv(models: TVShow)
    case person(persons: Person)
}
