//
//  Person.swift
//  Movie Time
//
//  Created by Yury Kruk on 25.01.2022.
//

import Foundation

struct Person: Codable {
    let profilePath: String?
    let adult: Bool?
    let id: Int
    let knownFor: [Media]?
    let knownForDepartment: String
    let name: String
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case profilePath = "profile_path"
        case adult, id
        case knownFor = "known_for"
        case knownForDepartment = "known_for_department"
        case name, popularity
    }
}
