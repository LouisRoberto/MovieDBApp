//
//  MovieVideosView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI
import Kingfisher

struct MovieVideosView: View {
    let movieId: Int
    @StateObject private var viewModel = MovieVideosViewModel()
    @State private var showVideoPlayer = false
    @State private var selectedVideo: MovieVideo?
    
    private let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.leading, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                if viewModel.videos.isEmpty && !viewModel.isLoading {
                    Text("No trailers available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.videos) { video in
                                trailerThumbnail(video: video)
                                    .frame(minHeight: 160)
                            }
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    }
                    .sheet(isPresented: $showVideoPlayer) {
                        if let video = selectedVideo {
                            YouTubePlayerContainer(video: video)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
            }
        }
        .navigationTitle("Trailers")
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .refreshable {
            Task {
                await viewModel.fetchMovieTrailers(movieId: movieId)
            }
        }
        .task {
            await viewModel.fetchMovieTrailers(movieId: movieId)
        }
    }
    
    private func trailerThumbnail(video: MovieVideo) -> some View {
        Button(action: {
            selectedVideo = video
            showVideoPlayer = true
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
                            .frame(width: 176, height: 120)
                            .clipped()
                    } else {
                        Color.gray
                            .frame(width: 176, height: 120)
                    }
                    
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                        .shadow(radius: 5)
                }
                .frame(width: 176, height: 120)
                .cornerRadius(4)
                
                Text(video.name)
                    .font(.caption)
                    .lineLimit(2)
                    .frame(width: 176, alignment: .leading)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct YouTubePlayerContainer: View {
    let video: MovieVideo
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text(video.name)
                    .font(.headline)
                    .padding(.horizontal)
                Spacer()
            }
            .padding(.top, 20)
            
            Spacer()
            
            VideoPlayerView(videoID: video.key)
                .frame(height: 300)
                .padding(.horizontal)
            
            Spacer()
        }
    }
}
