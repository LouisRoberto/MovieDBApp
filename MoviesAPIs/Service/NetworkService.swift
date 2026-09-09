//
//  NetworkService.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation
import Combine

protocol NetworkServiceProtocol {
    func fetchListMovies(category: MovieCategory) -> AnyPublisher<MoviesResponse, Error>
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetail, Error>
    func fetchMovieVideos(movieId: Int) -> AnyPublisher<MovieVideosResponse, Error>
    
    func fetchTvShowList(category: TVCategory) -> AnyPublisher<TvShowListResponse, Error>
    func fetchTvShowDetail(tvShowId: Int) -> AnyPublisher<TvShowDetail, Error>
}


class NetworkService: NetworkServiceProtocol {
    
    private let cache = NSCache<NSString, NSData>()
    
    func fetchListMovies(category: MovieCategory) -> AnyPublisher<MoviesResponse, Error> {
        let urlString = "\(MovieDBAPI.BASE_URL)\(category.endpoint)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MoviesResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        
        //Adding cache to movie details
        let cacheKey = NSString(string: "movie_\(movieId)")
        
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return Just(cachedData)
                .decode(type: MovieDetail.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(MovieDBAPI.movieDetailsEndpoint)\(movieId)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchMovieVideos(movieId: Int) -> AnyPublisher<MovieVideosResponse, Error> {
        let urlString = "\(MovieDBAPI.movieDetailsEndpoint)\(movieId)\(MovieDBAPI.videosPath)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: MovieVideosResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTvShowList(category: TVCategory) -> AnyPublisher<TvShowListResponse, Error> {
        let urlString = "\(MovieDBAPI.BASE_URL)\(category.endpoint)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TvShowListResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetchTvShowDetail(tvShowId: Int) -> AnyPublisher<TvShowDetail, Error> {
        
        //Adding cache to tv show details
        let cacheKey = NSString(string: "tv\(tvShowId)")
        
        if let cachedData = cache.object(forKey: cacheKey) as Data? {
            return Just(cachedData)
                .decode(type: TvShowDetail.self, decoder: JSONDecoder())
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }
        
        let urlString = "\(MovieDBAPI.tvShowDetailsEndpoint)\(tvShowId)"
        let url = MovieDBAPI.buildURL(url: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: TvShowDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
