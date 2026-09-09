//
//  TVListResponse.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

struct TvShowListResponse: Codable {
    let page: Int
    let results: [TvShow]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
        case page
    }
}

struct TvShow: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let originalLanguage: String
    let overview: String
    let posterPath: String?
    let firstAirDate: String
    let voteAverage: Double
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case originalLanguage = "original_language"
    }
    
    var fullPosterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w300\(path)")
        }
        return nil
    }
}
