//
//  PopularMoviesViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var results: [Movie] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    @Published var selectedCategory: MovieCategory = .popular
    @Published var categories: [MovieCategory] = [.popular, .nowPlaying, .topRated, .upcoming, .trending, .discover]
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    func fetchMovies() {
        isLoading = true
        error = nil
        
        networkService.fetchListMovies(category: selectedCategory)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = NetworkError.map(error)
                }
            }, receiveValue: { [weak self] response in
                self?.results = response.results
            })
            .store(in: &cancellables)
    }
    
    @MainActor
    func fetchMoviesList() async {
        isLoading = true
        error = nil
        do {
            async let moviesTask = apiClient.fetchListMovies(category: selectedCategory)
            let moviesResult = try await moviesTask
            isLoading = false
            self.results = moviesResult.results
        } catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
    
}
