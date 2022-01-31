//
//  TrendingViewModel.swift
//  Movie Time
//
//  Created by Yury Kruk on 17.01.2022.
//

import Foundation

struct TrendingViewModel {
    let section: TrendingSectionViewModel
    var movie: [Movie]
    var page: Int = 1
    var isPaginating: Bool = false
}

enum TrendingSectionViewModel: String {
    case nowTrending = "Now Trending"
    case recommended = "Recommended"
    case popular = "Popular"
    case upcoming = "Upcoming"
}
