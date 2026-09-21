//
//  MovieRow.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI
import Kingfisher

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if let url = movie.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 120, height: 180)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.title2)
                    .bold()
                HStack {
                    Text("movies.release".localized())
                        .font(.subheadline)
                    Text(movie.releaseDate.prefix(4))
                        .font(.subheadline)
                }
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", movie.voteAverage))
                }
            }
        }
    }
}
