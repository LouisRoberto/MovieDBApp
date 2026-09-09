//
//  Genre.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

struct Genre: Codable, Identifiable, Hashable{
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }
}
