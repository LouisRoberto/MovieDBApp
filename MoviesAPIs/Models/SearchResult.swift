//
//  SearchResult.swift
//  MoviesAPIs
//
//  Created by mac on 18/9/26.
//

import Foundation

enum MediaType: String, Codable {
    case movie
    case tv
    case person
    
    var displayName: String {
        switch self {
        case .movie: return "search.media.type.movie".localized()
        case .tv: return "search.media.type.tv".localized()
        case .person: return "search.media.type.person".localized()
        }
    }
}

struct SearchResult: Codable, Identifiable {
    let id: Int
    let mediaType: MediaType?
    let title: String?          // For movies
    let name: String?           // For TV shows
    let overview: String?
    let posterPath: String?
    let profilePath: String?    // For people
    let backdropPath: String?
    let releaseDate: String?    // For movies
    let firstAirDate: String?   // For TV shows
    let voteAverage: Double?
    let popularity: Double?
    
    // Computed title that works for both movies and TV shows
    var displayTitle: String {
        return title ?? name ?? "Unknown"
    }
    
    // Computed release year
    var releaseYear: String? {
        let dateString = releaseDate ?? firstAirDate
        guard let date = dateString, !date.isEmpty else { return nil }
        return String(date.prefix(4))
    }
    
    // Poster URL
    var posterURL: URL? {
        guard let path = posterPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
    }
    
    // Profile URL for people
    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w185\(path)")
    }
    
    // Get the appropriate image URL based on media type
    var imageURL: URL? {
        return mediaType == .person ? profileURL : posterURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case mediaType = "media_type"
        case title
        case name
        case overview
        case posterPath = "poster_path"
        case profilePath = "profile_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case popularity
    }
}

struct SearchResponse: Codable {
    let page: Int
    let results: [SearchResult]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// Multi-search specific filter
enum SearchFilter: String, CaseIterable {
    case all = "all"
    case movies = "movies"
    case tvShows = "tvShows"
    
    var localizedTitle: String {
        switch self {
        case .all: return "search.filter.all".localized()
        case .movies: return "search.filter.movie".localized()
        case .tvShows: return "search.filter.tv".localized()
        }
    }
    
    var mediaType: String? {
        switch self {
        case .all: return nil
        case .movies: return "movie"
        case .tvShows: return "tv"
        }
    }
    
    var icon: String {
        switch self {
        case .all: return "square.grid.2x2"
        case .movies: return "film"
        case .tvShows: return "tv"
        }
    }
    
    var endpoint: String {
        switch self {
        case .all: return "/search/multi"
        case .movies: return "/search/movie"
        case .tvShows: return "/search/tv"
        }
    }
}
