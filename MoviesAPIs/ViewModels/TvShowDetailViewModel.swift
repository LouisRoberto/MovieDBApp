//
//  TvShowDetailViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation
import Combine

class TvShowDetailViewModel: ObservableObject {
    @Published var tvShowDetail: TvShowDetail?
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchTVShowDetails(tvShowId: Int) {
        isLoading = true
        error = nil
        
        networkService.fetchTvShowDetail(tvShowId: tvShowId)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.error = NetworkError.map(error)
                }
            }, receiveValue: { [weak self] detail in
                self?.tvShowDetail = detail
            })
            .store(in: &cancellables)
    }
}

