//
//  MovieDBAPI.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

struct MovieDBAPI {
    
    static let apiKey = "195c892be42af154ce7ca9024aaa450b"
    static let videosPath = "/videos"
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let movieDetailsEndpoint : String = BASE_URL + "/movie/"
    static let tvShowDetailsEndpoint : String = BASE_URL + "/tv/"
    
    private static var languageQueryItem: URLQueryItem {
        URLQueryItem(name: "language", value: LanguageManager.shared.languageCode)
    }
    
    private static var regionQueryItem: URLQueryItem {
        URLQueryItem(name: "region", value: LanguageManager.shared.regionCode)
    }
    
    private static var adultQueryItem: URLQueryItem {
        URLQueryItem(name: "include_adult", value: "true")
    }
    
    private static var defaultQueryItems: [URLQueryItem] {
        [
            URLQueryItem(name: "api_key", value: apiKey),
            languageQueryItem,
            regionQueryItem,
            adultQueryItem
        ]
    }
    
    // Helper method to build URLs
    public static func buildURL(url: String, additionalQueryItems: [URLQueryItem] = []) -> URL? {
        var components = URLComponents(string: url)
        components?.queryItems = defaultQueryItems + additionalQueryItems
        return components?.url
    }
}
