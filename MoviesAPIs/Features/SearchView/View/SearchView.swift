//
//  SearchView.swift
//  MoviesAPIs
//
//  Created by mac on 18/9/26.
//


import SwiftUI
import Kingfisher

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @FocusState private var isSearchFocused: Bool
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                searchBar
                
                // Filter Chips
                filterChips
                
                // Content
                content
            }
            .onTapGesture {
                hideKeyboard()
            }
            .navigationTitle("search.title".localized())
        }
        .navigationViewStyle(.stack)
        .onAppear {
            // Optional: auto focus on appear
            // isSearchFocused = true
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("search.holder.msg".localized(), text: $viewModel.query)
                .focused($isSearchFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .submitLabel(.search)
                .onSubmit {
                    Task {
                        await viewModel.performSearch(query: viewModel.query)
                    }
                }
            
            if !viewModel.query.isEmpty {
                Button(action: {
                    viewModel.clearSearch()
                    isSearchFocused = false
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
    
    // MARK: - Filter Chips
    
    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(SearchFilter.allCases, id: \.self) { filter in
                    FilterChip(
                        title: filter.rawValue,
                        icon: filter.icon,
                        isSelected: viewModel.filter == filter
                    ) {
                        Task {
                            await viewModel.updateFilter(filter)
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if viewModel.query.isEmpty {
            // Show recent searches when query is empty
            recentSearchesView
        } else if viewModel.isLoading && viewModel.results.isEmpty {
            // Loading state
            loadingView
        } else if let error = viewModel.error {
            // Error state
            ErrorView(error: error)
        } else if viewModel.results.isEmpty {
            // No results
            noResultsView
        } else {
            // Results grid
            resultsGrid
        }
    }
    
    // MARK: - Recent Searches
    
    private var recentSearchesView: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !viewModel.recentSearches.isEmpty {
                HStack {
                    Text("Recent Searches")
                        .font(.headline)
                    
                    Spacer()
                    
                    Button("Clear") {
                        withAnimation {
                            viewModel.clearRecentSearches()
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
                
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.recentSearches, id: \.self) { search in
                            RecentSearchRow(
                                search: search,
                                onTap: {
                                    Task {
                                        await viewModel.selectRecentSearch(search)
                                        isSearchFocused = false
                                    }
                                },
                                onDelete: {
                                    viewModel.removeRecentSearch(search)
                                }
                            )
                            
                            if search != viewModel.recentSearches.last {
                                Divider()
                                    .padding(.leading, 52)
                            }
                        }
                    }
                }
            } else {
                // Empty state for recent searches
                VStack(spacing: 16) {
                    Spacer()
                    
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 60))
                        .foregroundColor(.secondary.opacity(0.5))
                    
                    Text("search.header".localized())
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("search.desc".localized())
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text("Searching...")
                .foregroundColor(.secondary)
                .padding(.top, 12)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - No Results View
    
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("search.empty_prompt".localized())
                .font(.headline)
            
            Text("search.retry.prompt".localized())
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Results Grid
    
    private var resultsGrid: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(columns: makeColumns(for: geometry.size.width),
                          spacing: 24) {
                    ForEach(viewModel.results) { result in
                        SearchResultCard(result: result)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
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

// MARK: - Supporting Views

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.caption)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(isSelected ? .black : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.yellow : Color(.secondarySystemBackground))
            )
            .overlay(
                Capsule()
                    .stroke(Color(.separator), lineWidth: isSelected ? 0 : 0.5)
            )
        }
    }
}

struct RecentSearchRow: View {
    let search: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "clock.arrow.circlepath")
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            Text(search)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}

struct SearchResultCard: View {
    let result: SearchResult
    @State private var isPressed = false
    
    var body: some View {
        NavigationLink(destination: destinationView) {
            VStack(alignment: .leading, spacing: 6) {
                // Image
                ZStack(alignment: .topTrailing) {
                    if let url = result.imageURL {
                        KFImage(url)
                            .resizable()
                            .placeholder {
                                Color.gray.opacity(0.3)
                                    .overlay(ProgressView())
                            }
                            .aspectRatio(contentMode: .fill)
                            .frame(height: ResponsiveLayout.posterSize.height)
                            .frame(maxWidth: .infinity)
                            .clipped()
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
                    Text(result.mediaType?.displayName ?? "")
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
                
                // Title
                Text(result.displayTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 4)
                
                // Rating and Year
                HStack(spacing: 6) {
                    if let rating = result.voteAverage, rating > 0 {
                        HStack(spacing: 2) {
                            Image(systemName: "star.fill")
                                .font(.caption2)
                                .foregroundColor(.yellow)
                            
                            Text(String(format: "%.1f", rating))
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
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
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    @ViewBuilder
    private var destinationView: some View {
        switch result.mediaType {
        case .movie:
            MovieDetailByIdView(movieId: result.id)
        case .tv:
            TVShowDetailByIdView(showId: result.id)
        case .person:
            EmptyView()
        case .none:
            EmptyView()
        }
    }
}

