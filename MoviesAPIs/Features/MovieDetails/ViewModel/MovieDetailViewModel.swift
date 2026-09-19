//
//  MovieDetailSModelView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation
import Combine

class MovieDetailViewModel: ObservableObject {
    @Published var movieDetail: MovieDetail?
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    func fetchMovieDetails(movieId: Int) {
        isLoading = true
        error = nil
        
        networkService.fetchMovieDetails(movieId: movieId)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = NetworkError.map(error)
                }
            }, receiveValue: { [weak self] detail in
                self?.movieDetail = detail
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchMovieInfos(movieId: Int) async {
        isLoading = true
        error = nil
        do {
            async let movieDetailTask = apiClient.fetchMovieDetails(movieId: movieId)
            let movieDetailResult = try await movieDetailTask
            isLoading = false
            self.movieDetail = movieDetailResult
        }catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
}

