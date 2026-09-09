//
//  MovieVideosResponse.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

struct MovieVideosResponse: Codable {
    let results: [MovieVideo]
}

struct MovieVideo: Codable, Identifiable {
    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    
    var youtubeURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
    
    var youtubeThumbnailURL: URL? {
        guard site.lowercased() == "youtube" else { return nil }
        return URL(string: "https://img.youtube.com/vi/\(key)/0.jpg")
    }
}
