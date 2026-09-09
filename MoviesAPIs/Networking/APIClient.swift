//
//  APIClient.swift
//  MoviesAPIs
//
//  Created by mac on 29/10/25.
//

import Foundation

protocol APIClientProtocol {
    func fetchListMovies(category: MovieCategory) async throws -> MoviesResponse
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail
    func fetchMovieVideos(movieId: Int) async throws -> MovieVideosResponse
    
    func fetchTvShowList(category: TVCategory) async throws -> TvShowListResponse
    func fetchTvShowDetail(tvShowId: Int) async throws -> TvShowDetail
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    private let session: URLSessionProtocol
    private let cache = NSCache<NSString, NSData>()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchListMovies(category: MovieCategory) async throws -> MoviesResponse {
        let urlString = "\(MovieDBAPI.BASE_URL)\(category.endpoint)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(MoviesResponse.self, from: data)
    }
    
    func fetchMovieDetails(movieId: Int) async throws -> MovieDetail {
        let cacheKey = NSString(string: "movie_\(movieId)")
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return try JSONDecoder().decode(MovieDetail.self, from: cachedData)
        }
        let urlString = "\(MovieDBAPI.movieDetailsEndpoint)\(movieId)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(MovieDetail.self, from: data)
    }
    
    func fetchMovieVideos(movieId: Int) async throws -> MovieVideosResponse {
        let urlString = "\(MovieDBAPI.movieDetailsEndpoint)\(movieId)\(MovieDBAPI.videosPath)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(MovieVideosResponse.self, from: data)
    }
    
    func fetchTvShowList(category: TVCategory) async throws -> TvShowListResponse {
        let urlString = "\(MovieDBAPI.BASE_URL)\(category.endpoint)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(TvShowListResponse.self, from: data)
    }
    
    func fetchTvShowDetail(tvShowId: Int) async throws -> TvShowDetail {
        let cacheKey = NSString(string: "tv\(tvShowId)")
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return try JSONDecoder().decode(TvShowDetail.self, from: cachedData)
        }
        
        let urlString = "\(MovieDBAPI.tvShowDetailsEndpoint)\(tvShowId)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        let (data, _) = try await session.data(from: url)
        return try JSONDecoder().decode(TvShowDetail.self, from: data)
    }
}
