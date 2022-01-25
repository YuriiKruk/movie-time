//
//  MediaViewModel.swift
//  Movie Time
//
//  Created by Yury Kruk on 20.01.2022.
//

import Foundation

struct MovieViewModel {
    let posterURL: String?
    
    let title: String
    let releaseDate: String?
    let overview: String
    let rating: String
    let popularity: Double?
    let adult: Bool?
    
    let genres: [String]
}
