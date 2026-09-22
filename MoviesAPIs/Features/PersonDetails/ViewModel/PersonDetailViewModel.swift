//
//  PersonDetailViewModel.swift
//  MoviesAPIs
//
//  Created by mac on 22/9/26.
//

import Foundation

class PersonDetailViewModel: ObservableObject {
    
    @Published var personDetail: PersonDetail?
    @Published var isLoading = false
    @Published var error: NetworkError?
    
    private let apiClient: APIClientProtocol
    
    init(apiClient: APIClient = APIClient()) {
        self.apiClient = APIClient()
    }
    
    @MainActor
    func fetchPersonInfos(personId: Int) async {
        isLoading = true
        error = nil
        do {
            async let personDetailTask = apiClient.fetchPersonDetail(personId: personId)
            let personDetailResult = try await personDetailTask
            isLoading = false
            self.personDetail = personDetailResult
        }catch {
            isLoading = false
            self.error = NetworkError.map(error)
        }
    }
}
