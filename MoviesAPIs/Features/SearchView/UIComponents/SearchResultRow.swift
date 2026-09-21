//
//  SearchResultRow.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI
import Kingfisher

struct SearchResultRow: View {
    let result: SearchResult
    
    var body: some View {
        HStack {
            if let url = result.imageURL {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 120, height: 180)
                    .cornerRadius(4)
            } else {
                Image(systemName: result.mediaType == .tv ? "tv" : "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
                    .background(Color(.secondarySystemBackground))
                    .frame(width: 120, height: 180)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading) {
                Text(result.displayTitle)
                    .font(.title2)
                    .bold()
                if let year = result.releaseYear {
                    HStack {
                        Text("movies.release".localized())
                            .font(.subheadline)
                        Text(year)
                            .font(.subheadline)
                    }
                }
                if let rating = result.voteAverage, rating > 0 {
                    HStack {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text(String(format: "%.1f", result.voteAverage ?? 0))
                    }
                }
                
                // Media Type Badge
                if let mediaType = result.mediaType {
                    Text(mediaType.displayName)
                        .font(.subheadline)
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
        }
    }
}
