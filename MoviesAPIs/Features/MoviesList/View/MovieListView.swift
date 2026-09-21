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
            LoadingView(title: "common.loading".localized())

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
                    columns: Helper.shared.makeColumns(for: geometry.size.width),
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
}
