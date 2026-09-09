//
//  URLSessionProtocol.swift
//  MoviesAPIs
//
//  Created by mac on 29/10/25.
//

import Foundation

// Protocol to make URLSession mockable for testing
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// Make the standard URLSession conform to our protocol
extension URLSession: URLSessionProtocol {}
