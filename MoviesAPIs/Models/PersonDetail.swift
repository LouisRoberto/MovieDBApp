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
    let gender: Gender
    
    enum CodingKeys: String, CodingKey {
        case id, name, biography, birthday, popularity, homepage, gender
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

enum Gender: Int, Codable {
    case notSet = 0
    case female = 1
    case male = 2
    case nonBinary = 3

    var displayName: String {
        switch self {
        case .notSet:
            return "Not specified"
        case .female:
            return "person.gender.female".localized()
        case .male:
            return "person.gender.male".localized()
        case .nonBinary:
            return "person.gender.nonbinary".localized()
        }
    }
}
