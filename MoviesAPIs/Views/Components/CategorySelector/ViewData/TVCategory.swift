//
//  TVCategory.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation

enum TVCategory: String, Category {
    case popularTV
    case airingToday
    case onTheAir
    case topRatedTV
    case discoverTV
    
    var endpoint: String {
        switch self {
        case .airingToday: return "/tv/airing_today"
        case .onTheAir: return "/tv/on_the_air"
        case .topRatedTV: return "/tv/top_rated"
        case .popularTV: return "/tv/popular"
        case .discoverTV: return "/discover/tv"
        }
    }
}
