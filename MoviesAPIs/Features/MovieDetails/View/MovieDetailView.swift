//
//  MovieDetailView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    
    let movieId: Int
    let movieTiltle: String
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var showVideoPlayer = false
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView(title: "Loading...")
            } else if let error = viewModel.error {
                ErrorView(error: error)
            } else if let movieDetail = viewModel.movieDetail {
                movieContent(for: movieDetail)
            }
        }
        .navigationTitle(movieTiltle)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .refreshable {
            Task {
                await viewModel.fetchMovieInfos(movieId: movieId)
            }
        }
        .task {
            await viewModel.fetchMovieInfos(movieId: movieId)
        }
    }
    
    @ViewBuilder
    private func movieContent(for movie: MovieDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Movie Poster and Basic Info
                headerSection(movie: movie)
                
                // Rating and Release Date
                infoBadges(movie: movie)
                
                // Movie Overview
                overviewSection(movie: movie)
                
                // Trailer Overview
                trailerSection(movieId: movie.id)
                
                if let homepage = movie.homepage, !homepage.isEmpty, Helper.shared.isValidURL(homepage) {
                    homepageLink(homePageLink: homepage)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct headerSection: View {
    let movie: MovieDetail
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Movie Poster
            if let url = movie.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 210)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image(systemName: "film")
                    .frame(width: 140, height: 210)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            
            // Title and Basic Info
            VStack(alignment: .leading, spacing: 8) {
                Text(movie.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text(movie.releaseDate.prefix(4))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\(movie.runtime / 60)h \(movie.runtime % 60)m")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Genres
                if let genres = movie.genres, !genres.isEmpty {
                    FlexibleView(
                        data: genres.prefix(3),
                        spacing: 6,
                        alignment: .leading
                    ) { genre in
                        Text(genre.name)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.yellow)
                            .foregroundColor(Color.black)
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: 180)
                    .padding(.leading, 6)
                }
            }
            
            Spacer()
        }
    }
}

struct infoBadges: View {
    let movie: MovieDetail
    
    var body: some View {
        HStack(spacing: 16) {
            // Rating
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", movie.voteAverage))
                    .fontWeight(.semibold)
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            // Release Date
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                
                Text(movie.releaseDate.changeFormat(from: .dashedReversedDateFormat, to: .slashedDateFormat))
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
        
        Spacer()
    }
}

struct overviewSection: View {
    let movie: MovieDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movie.overview".localized())
                .font(.headline)
            
            Text(movie.overview)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct trailerSection: View {
    @StateObject private var videosViewModel = MovieVideosViewModel()
    let movieId: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("movie.trailers".localized())
                    .font(.headline)
                
                if videosViewModel.isLoading {
                    ProgressView()
                        .padding(.leading, 8)
                }
            }
            
            if videosViewModel.videos.isEmpty && !videosViewModel.isLoading {
                Text("movie.no.trailers".localized())
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(videosViewModel.videos) { video in
                            trailerThumbnail(video: video)
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .onAppear {
            if videosViewModel.videos.isEmpty {
                videosViewModel.fetchMovieVideos(movieId: movieId)
            }
        }
    }
}

struct trailerThumbnail: View {
    let video: MovieVideo
    @State private var showVideoPlayer: Bool = false
    
    var body: some View {
        Button(action: {
            showVideoPlayer.toggle()
        }) {
            VStack(alignment: .leading, spacing: 8) {
                ZStack {
                    if let thumbnailURL = video.youtubeThumbnailURL {
                        KFImage(thumbnailURL)
                            .resizable()
                            .placeholder {
                                ProgressView()
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 240, height: 136)
                            .clipped()
                    } else {
                        Color.gray
                            .frame(width: 240, height: 136)
                    }
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white).shadow(radius: 5)
                }
                .frame(width: 240, height: 136)
                .cornerRadius(8)
                
                Text(video.name)
                    .font(.footnote)
                    .lineLimit(2)
                    .frame(width: 240, height: 40, alignment: .leading)
            }
            .sheet(isPresented: $showVideoPlayer) {
                YouTubePlayerContainer(video: video)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct homepageLink: View {
    let homePageLink: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movie.website".localized())
                .font(.headline)
            
            Button(action: {
                Helper.shared.openURL(homePageLink)
            }) {
                HStack {
                    Image(systemName: "safari")
                    Text("movie.visit".localized())
                        .underline()
                    Spacer()
                    Image(systemName: "arrow.up.forward")
                }
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            }
        }
    }
}
