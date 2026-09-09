//
//  MovieDetails.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let budget: Int
    let revenue: Int
    let homepage: String?
    let runtime: Int
    let genres: [Genre]?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, budget, revenue, homepage, runtime, genres
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    var fullPosterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
}
