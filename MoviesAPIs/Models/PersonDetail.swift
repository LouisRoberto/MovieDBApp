//
//  PersonDetail.swift
//  MoviesAPIs
//
//  Created by mac on 22/9/26.
//

import Foundation

struct PersonDetail: Codable {
    let id: Int
    let name: String
    let biography: String
    let profilePath: String?
    let birthday: String
    let popularity: Double
    let knownFor: String
    let placeOfBirth: String
    let homepage: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday, popularity, homepage
        case profilePath = "profile_path"
        case knownFor = "known_for_department"
        case placeOfBirth = "place_of_birth"
    }
    
    var fullPosterURL: URL? {
        if let path = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
}
