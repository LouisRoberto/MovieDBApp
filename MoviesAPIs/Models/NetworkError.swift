//
//  NetworkError.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case invalidResponse
    case notFound
    case serverError(String)
    case decodingError
    case rateLimitExceeded
    case noInternetConnection
    case unknown
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "error.invalid_url".localized()
        case .invalidResponse:
            return "error.invalid_response".localized()
        case .notFound:
            return "error.not_found".localized()
        case .serverError(let message):
            return "error.server_error".localized(with: message)
        case .decodingError:
            return "error.decoding".localized()
        case .rateLimitExceeded:
            return "error.rate_limit".localized()
        case .noInternetConnection:
            return "error.no_internet".localized()
        case .unknown:
            return "error.unknown".localized()
        case .noData:
            return "error.no_data".localized()
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
        case .invalidURL: return "search.placeholder".localized()
        case .notFound: return "search.empty_prompt".localized()
        case .rateLimitExceeded: return "common.retry".localized()
        case .noInternetConnection: return "common.no_internet".localized()
        default: return "common.retry".localized()
        }
    }
    
    static func map(_ error: Error) -> NetworkError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let error as URLError where error.code == .notConnectedToInternet:
            return .noInternetConnection
        case let error as URLError where error.code == .timedOut:
            return .serverError("Request timed out")
        case let error as NetworkError:
            return error
        default:
            return .unknown
        }
    }
}
