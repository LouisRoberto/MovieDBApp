//
//  MovieGridItem.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI
import Kingfisher

struct MovieGridItem: View {
    let movie: Movie
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Movie Poster
            if let url = movie.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ProgressView()
                            .frame(height: ResponsiveLayout.posterSize.height)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: ResponsiveLayout.posterSize.height)
                    .cornerRadius(12)
                
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: ResponsiveLayout.posterSize.height)
                    .foregroundColor(.gray)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }
            
            // Movie Title
            Text(movie.title)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .padding(.horizontal, 4)
            
            // Rating
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .imageScale(.small)
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", movie.voteAverage))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 4)
            .padding(.bottom, 4)
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        .frame(maxWidth: ResponsiveLayout.isIPad ? .infinity : nil)
    }
}
