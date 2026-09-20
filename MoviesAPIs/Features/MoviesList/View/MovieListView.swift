//
//  MovieListView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI
import Kingfisher

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @State private var selectedMovie: Movie?

    var body: some View {
        Group {
            if ResponsiveLayout.isIPad {
                iPadContent
            } else {
                iPhoneContent
            }
        }
        .task {
            await viewModel.fetchMoviesList()
        }
        .onChange(of: viewModel.selectedCategory) { _ in
            Task {
                await viewModel.fetchMoviesList()
            }
        }
    }

    // MARK: - iPad

    private var iPadContent: some View {
        VStack(spacing: 0) {
            CategorySelectorView(
                categories: viewModel.categories,
                selectedCategory: $viewModel.selectedCategory
            )

            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("movies.title".localized())
        .sheet(item: $selectedMovie) { movie in
            NavigationStack {
                MovieDetailsIpad(movieId: movie.id, movieTiltle: movie.title)
                    .navigationTitle(movie.title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("common.done".localized()) {
                                selectedMovie = nil
                            }
                        }
                    }
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }

    // MARK: - iPhone

    private var iPhoneContent: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CategorySelectorView(
                    categories: viewModel.categories,
                    selectedCategory: $viewModel.selectedCategory
                )

                content
            }
            .navigationTitle("movies.title".localized())
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else if let error = viewModel.error {
            ErrorView(error: error)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else if viewModel.results.isEmpty {
            Text("movies.empty_prompt".localized())
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        } else {
            if ResponsiveLayout.isIPad {
                iPadLayout
            } else {
                iPhoneLayout
            }
        }
    }

    // MARK: - iPhone Layout

    private var iPhoneLayout: some View {
        List(viewModel.results) { movie in
            NavigationLink {
                MovieDetailView(movieId: movie.id, movieTiltle: movie.title)
            } label: {
                MovieRow(movie: movie)
            }
        }
    }

    // MARK: - iPad Layout

    private var iPadLayout: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(
                    columns: makeColumns(for: geometry.size.width),
                    spacing: 24
                ) {
                    ForEach(viewModel.results) { movie in
                        MovieGridItem(movie: movie)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedMovie = movie
                            }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.vertical, 24)
                .frame(
                    minWidth: geometry.size.width,
                    alignment: .center
                )
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
    }

    private func makeColumns(for width: CGFloat) -> [GridItem] {
        let minimumCardWidth: CGFloat = 180
        let spacing: CGFloat = 24

        let availableWidth = width - 48

        let numberOfColumns = max(
            1,
            Int(
                (availableWidth + spacing) /
                (minimumCardWidth + spacing)
            )
        )

        return Array(
            repeating: GridItem(
                .flexible(),
                spacing: spacing
            ),
            count: numberOfColumns
        )
    }
}

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
