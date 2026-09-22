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
    @State private var selectedResult: SearchResult?
    
    var body: some View {
        Group {
            if ResponsiveLayout.isIPad {
                iPadContent
            } else {
                iPhoneContent
            }
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
                        title: filter.localizedTitle,
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
        .onTapGesture {
            isSearchFocused = false
            hideKeyboard()
        }
    }
    
    private var iPadContent: some View {
        VStack(spacing: 0) {
            searchBar
            filterChips
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("search.title".localized())
        .sheet(item: $selectedResult) { result in
            NavigationStack {
                if result.mediaType ==  .movie || viewModel.filter == .movies {
                    MovieDetailsIpad(movieId: result.id, movieTiltle: result.displayTitle)
                        .navigationTitle(result.displayTitle)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("common.done".localized()) {
                                    selectedResult = nil
                                }
                            }
                        }
                } else if result.mediaType ==  .tv  || viewModel.filter == .tvShows {
                    TVShowDetailsIpad(tvShowId: result.id, tvShowName: result.name ?? "")
                        .navigationTitle(result.displayTitle)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("common.done".localized()) {
                                    selectedResult = nil
                                }
                            }
                        }
                } else if result.mediaType == .person {
                    PersonDetailView(personId: result.id, personName: result.name ?? "")
                        .navigationTitle(result.displayTitle)
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("common.done".localized()) {
                                    selectedResult = nil
                                }
                            }
                        }
                }
                
            }
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
    }
    
    private var iPhoneContent: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                filterChips
                content
            }
            .navigationTitle("search.title".localized())
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
            LoadingView(title: "search.loading.msg".localized())
        } else if let error = viewModel.error {
            // Error state
            ErrorView(error: error)
        } else if viewModel.results.isEmpty {
            // No results
            noResultsView
        } else {
            if ResponsiveLayout.isIPad {
                iPadLayout
            } else {
                iPhoneLayout
            }
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
    
    
    // MARK: - No Results View
    
    private var noResultsView: some View {
        VStack(spacing: 16) {
            Spacer()
            
            Image(systemName: "magnifyingglass")
                .font(.system(size: 50))
                .foregroundColor(.secondary.opacity(0.5))
            
            Text("search.empty.prompt".localized())
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
    
    // MARK: - iPhone Layout
    
    private var iPhoneLayout: some View {
        List(viewModel.results) { result in
            NavigationLink {
                if result.mediaType ==  .movie || viewModel.filter == .movies {
                    MovieDetailView(movieId: result.id, movieTiltle: result.title ?? "")
                } else if result.mediaType ==  .tv  || viewModel.filter == .tvShows {
                    TvShowDetailView(tvShowId: result.id, tvShowName: result.name ?? "")
                } else if result.mediaType ==  .person {
                    PersonDetailView(personId: result.id, personName: result.name ?? "")
                }
            } label: {
                SearchResultRow(result: result)
            }
        }
    }
    
    // MARK: - Results Grid
    
    private var iPadLayout: some View {
        GeometryReader { geometry in
            ScrollView {
                LazyVGrid(
                    columns: Helper.shared.makeColumns(for: geometry.size.width),
                    spacing: 24
                ) {
                    ForEach(viewModel.results) { result in
                        SearchResultCard(result: result)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedResult = result
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 20)
            }
        }
    }
}
