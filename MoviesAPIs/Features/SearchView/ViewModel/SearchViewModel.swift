//
//  SearchViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 18/9/26.
//

import Foundation
import Combine

@MainActor
class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var filter: SearchFilter = .all
    
    @Published var results: [SearchResult] = []
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    @Published var recentSearches: [String] = []
    
    private let apiClient: APIClientProtocol
    
    private let recentSearchesKey = "recentSearches"
    
    private var cancellables = Set<AnyCancellable>()
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
        loadRecentSearches()
        setupSearchDebounce()
    }
    
    // MARK: - Debounced Search
    private func setupSearchDebounce() {
        $query
            .debounce(for: .milliseconds(400), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                if query.trimmingCharacters(in: .whitespaces).isEmpty {
                    self.results = []
                    return
                }
                Task { [weak self] in
                    guard let self else { return }
                    await self.performSearch(query: query)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Search
    @MainActor
    func performSearch(query: String) async {
        isLoading = true
        error = nil
        do {
            async let searchTask = apiClient.search(query: query, filter: filter, page: 1)
            let searchResult = try await searchTask
            isLoading = false
            self.results = searchResult.results
        } catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
    
    @MainActor
    func updateFilter(_ newFilter: SearchFilter) async {
        filter = newFilter
        if !query.isEmpty {
            await performSearch(query: query)
        }
    }
    
    func clearSearch() {
        query = ""
        results = []
        error = nil
        isLoading = false
    }
    
    // MARK: - Recent Searches
    
    private func saveRecentSearch(_ search: String) {
        let trimmed = search.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        
        // Remove duplicates and add to front
        recentSearches.removeAll { $0.lowercased() == trimmed.lowercased() }
        recentSearches.insert(trimmed, at: 0)
        
        // Keep only the last 10
        if recentSearches.count > 10 {
            recentSearches = Array(recentSearches.prefix(10))
        }
        
        saveRecentSearchesToDisk()
    }
    
    func removeRecentSearch(_ search: String) {
        recentSearches.removeAll { $0 == search }
        saveRecentSearchesToDisk()
    }
    
    func clearRecentSearches() {
        recentSearches.removeAll()
        saveRecentSearchesToDisk()
    }
    
    private func loadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: recentSearchesKey) ?? []
    }
    
    private func saveRecentSearchesToDisk() {
        UserDefaults.standard.set(recentSearches, forKey: recentSearchesKey)
    }
    
    // MARK: - Selection
    func selectRecentSearch(_ search: String) async {
        query = search
        await performSearch(query: search)
    }
}

