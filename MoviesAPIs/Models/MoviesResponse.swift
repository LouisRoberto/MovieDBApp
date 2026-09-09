//
//  MovieResponse.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

struct MoviesResponse: Codable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
        case page
    }
}

struct Movie: Codable, Hashable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    var fullPosterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
        }
        return nil
    }
}
