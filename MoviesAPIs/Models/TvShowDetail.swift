//
//  TvShowDetail.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

struct TvShowDetail: Codable {
    let id: Int
    let name: String
    let overview: String
    let posterPath: String?
    let firstAirDate: String
    let voteAverage: Double
    let homepage: String?
    let type: String
    let genres: [Genre]?
    let networks: [Network]?
    let createdBy: [CreatedBy]?
    let productionCompanies: [ProductionCompany]?
    let numberOfSeasons: Int
    let originalLanguage: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, overview, homepage, type, genres, networks
        case posterPath = "poster_path"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case numberOfSeasons = "number_of_seasons"
        case originalLanguage = "original_language"
        case createdBy = "created_by"
        case productionCompanies = "production_companies"
    }
    
    var fullPosterURL: URL? {
        if let path = posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
        }
        return nil
    }
    
}
