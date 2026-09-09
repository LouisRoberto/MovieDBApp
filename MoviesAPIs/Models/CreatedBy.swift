//
//  CreatedBy.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

struct CreatedBy: Codable, Identifiable, Hashable{
    let id: Int
    let creditId: String
    let name: String
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case creditId = "credit_id"
        case profilePath = "profile_path"
    }
    
    var fullProfileURL: URL? {
        if let path = profilePath {
            return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
        }
        return nil
    }
}
