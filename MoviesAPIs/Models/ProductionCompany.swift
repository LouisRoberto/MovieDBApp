//
//  ProductionCompany.swift
//  MoviesAPIs
//
//  Created by mac on 9/9/26.
//

import Foundation

struct ProductionCompany: Codable, Identifiable, Hashable{
    let id: Int
    let name: String
    let logoPath: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case logoPath = "logo_path"
    }
    
    var fullLogoURL: URL? {
        if let path = logoPath {
            return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
        }
        return nil
    }
}

