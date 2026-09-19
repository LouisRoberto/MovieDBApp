//
//  MoviesCategory.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

enum MovieCategory: String, Category {
    case popular
    case nowPlaying
    case topRated
    case upcoming
    case trending
    case discover
    
    var endpoint: String {
        switch self {
        case .popular: return "/movie/popular"
        case .nowPlaying: return "/movie/now_playing"
        case .topRated: return "/movie/top_rated"
        case .upcoming: return "/movie/upcoming"
        case .trending: return "/trending/movie/day"
        case .discover: return "/discover/movie"
        }
    }
}
