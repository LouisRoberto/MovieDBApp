//
//  SearchResultCard.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI
import Kingfisher

struct SearchResultCard: View {
    let result: SearchResult
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Image
            ZStack(alignment: .topTrailing) {
                if let url = result.imageURL {
                    KFImage(url)
                        .resizable()
                        .placeholder {
                            ProgressView()
                                .frame(height: ResponsiveLayout.posterSize.height)
                        }
                        .frame(height: ResponsiveLayout.posterSize.height)
                        .frame(maxWidth: .infinity)
                        .cornerRadius(12)
                } else {
                    Image(systemName: result.mediaType == .tv ? "tv" : "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: ResponsiveLayout.posterSize.height)
                        .foregroundColor(.gray)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }
                
                // Media Type Badge
                if let mediaType = result.mediaType {
                    Text(mediaType.displayName)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(result.mediaType == .movie ? Color.blue : Color.purple)
                        )
                        .padding(8)
                }
            }
            
            // Title
            Text(result.displayTitle)
                .font(.title2)
                .bold()
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 4)
            
            // Rating and Year
            
            
            HStack(spacing: 2) {
                if let rating = result.voteAverage, rating > 0 {
                    Image(systemName: "star.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                    
                    Text(String(format: "%.1f", rating))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if let year = result.releaseYear {
                    Text(year)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                }
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
