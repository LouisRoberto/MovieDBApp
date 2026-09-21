//
//  MovieDetailsIpad.swift
//  MoviesAPIs
//
//  Created by mac on 7/9/26.
//

import SwiftUI
import Kingfisher

struct MovieDetailsIpad: View {
    
    let movieId: Int
    let movieTiltle: String
    
    @StateObject private var viewModel = MovieDetailViewModel()
    @State private var showVideoPlayer = false
    @State private var selectedVideo: MovieVideo?
    
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
            VStack(alignment: .leading, spacing: 20) {
                // Poster and Title Section
                posterAndTitleSection(movie: movie)
                
                // Info Badges
                infoBadgesIpad(movie: movie)
                
                // Overview
                overviewSectionIpad(movie: movie)
                
                // Trailer Overview
                trailerSectionIpad(movieId: movie.id)
                
                // Homepage Link
                if let homepage = movie.homepage, !homepage.isEmpty, Helper.shared.isValidURL(homepage) {
                    homepageLinkIpad(homePageLink: homepage)
                }
                
                Spacer()
            }
            .padding(.horizontal, ResponsiveLayout.isIPad ? 24 : 16)
            .padding(.vertical, 16)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showVideoPlayer) {
            if let video = selectedVideo {
                YouTubePlayerContainer(video: video)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
}

// MARK: - Poster and Title Section (Fixed)
struct posterAndTitleSection:  View {
    let movie: MovieDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                // Poster
                if let url = movie.fullPosterURL {
                    KFImage(url)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: ResponsiveLayout.posterSize.width,
                               height: ResponsiveLayout.posterSize.height)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                } else {
                    Image(systemName: "film")
                        .frame(width: ResponsiveLayout.posterSize.width,
                               height: ResponsiveLayout.posterSize.height)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(12)
                }
                
                // Title and info
                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(movie.releaseDate.changeFormat(from: .dashedReversedDateFormat, to: .slashedDateFormat))
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\(movie.runtime / 60)h \(movie.runtime % 60)m")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Genres - Now properly positioned below the HStack
            if let genres = movie.genres, !genres.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(genres, id: \.id) { genre in
                            Text(genre.name)
                                .font(.caption)
                                .fontWeight(.medium)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(12)
                        }
                    }
                }
                .padding(.top, 4)
            }
        }
    }
}

// MARK: - Info Badges
struct infoBadgesIpad: View {
    
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
            
            Spacer()
        }
    }
}

// MARK: - Overview Section
struct overviewSectionIpad: View {
    
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

// MARK: - Homepage Link

struct homepageLinkIpad: View {
    
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

// MARK: - Trailers Section
struct trailerSectionIpad:  View {
    
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
