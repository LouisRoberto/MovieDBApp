//
//  ErrorView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI

struct ErrorView: View {
    let error: NetworkError
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.orange)
            
            Text(error.localizedDescription)
                .font(.headline)
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
                .padding()
            
            if let suggestion = error.recoverySuggestion {
                Text(suggestion)
                .foregroundColor(.secondary)
                .padding()
            }
        }
        .padding()
    }
}
