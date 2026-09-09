//
//  MovieVideosViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation
import Combine

class MovieVideosViewModel: ObservableObject {
    @Published var videos: [MovieVideo] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    private let apiClient: APIClientProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
        self.apiClient = APIClient()
    }
    
    func fetchMovieVideos(movieId: Int) {
        isLoading = true
        error = nil
        
        networkService.fetchMovieVideos(movieId: movieId)
            .sink(receiveCompletion: { [weak self] completion in
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.error = NetworkError.map(error)
            }
        }, receiveValue: { [weak self] response in
            self?.videos = response.results
        })
        .store(in: &cancellables)
    }
    
    @MainActor
    func fetchMovieTrailers(movieId: Int) async {
        isLoading = true
        error = nil
        do {
            async let trailerTask = apiClient.fetchMovieVideos(movieId: movieId)
            let trailersResult = try await trailerTask
            isLoading = false
            self.videos = trailersResult.results
        } catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
}
