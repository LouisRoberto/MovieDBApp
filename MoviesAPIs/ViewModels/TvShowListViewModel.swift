//
//  TVListViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import Foundation
import Combine

class TvShowListViewModel: ObservableObject {
    @Published var results: [TvShow] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    @Published var selectedCategory: TVCategory = .airingToday
    @Published var categories: [TVCategory] = [.airingToday, .popularTV, .onTheAir, .topRatedTV, .discoverTV]
    
    private var cancellables = Set<AnyCancellable>()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchTvShowList() {
        isLoading = true
        error = nil
        
        networkService.fetchTvShowList(category: selectedCategory)
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
    
}
