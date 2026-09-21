//
//  TVListView.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import SwiftUI
import Kingfisher

struct TVShowListView: View {
    @StateObject private var viewModel = TvShowListViewModel()
    @State private var selectedShow: TvShow?
    
    var body: some View {
        Group {
            if ResponsiveLayout.isIPad {
                iPadContent
            } else {
                iPhoneContent
            }
        }
        .onAppear {
            viewModel.fetchTvShowList()
        }
        .onChange(of: viewModel.selectedCategory) { _ in
            viewModel.fetchTvShowList()
        }
    }
    
    // MARK: - iPad
    
    private var iPadContent: some View {
        VStack(spacing: 0) {
            TVSelectorView(
                categories: viewModel.categories,
                selectedCategory: $viewModel.selectedCategory
            )
            
            content
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("tv.title".localized())
        .sheet(item: $selectedShow) { tvShow in
            NavigationStack {
                TVShowDetailsIpad(tvShowId: tvShow.id, tvShowName: tvShow.name)
                    .navigationTitle(tvShow.name)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("common.done".localized()) {
                                selectedShow = nil
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
                TVSelectorView(
                    categories: viewModel.categories,
                    selectedCategory: $viewModel.selectedCategory
                )
                
                content
            }
            .navigationTitle("tv.title".localized())
        }
    }
    
    // MARK: - Content
    
    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading {
            LoadingView(title: "Loading...")
            
        } else if let error = viewModel.error {
            ErrorView(error: error)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        } else if viewModel.results.isEmpty {
            Text("tv.empty_prompt".localized())
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
        List(viewModel.results) { tvShow in
            NavigationLink {
                TvShowDetailView(tvShowId: tvShow.id, tvShowName: tvShow.name)
            } label: {
                TVShowRow(tvShow: tvShow)
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
                    ForEach(viewModel.results) { tvShow in
                        TVShowGridItem(show: tvShow)
                            .frame(maxWidth: .infinity)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedShow = tvShow
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

struct TVShowRow: View {
    let tvShow: TvShow
    
    var body: some View {
        HStack {
            if let url = tvShow.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .frame(width: 120, height: 180)
                    .cornerRadius(4)
            }
            
            VStack(alignment: .leading) {
                Text(tvShow.name)
                    .font(.title2)
                    .bold()
                HStack {
                    Text("tv.release".localized())
                        .font(.system(size: 12, weight: .regular))
                        .lineLimit(1)
                    
                    Text(tvShow.firstAirDate.changeFormat(from: .dashedReversedDateFormat, to: .slashedMonthYearFormat))
                        .font(.system(size: 13, weight: .regular))
                        .lineLimit(1)
                }
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", tvShow.voteAverage))
                }
            }
        }
    }
}

struct TVShowGridItem: View {
    let show: TvShow
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // TV Show Poster
            if let url = show.fullPosterURL {
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
                Image(systemName: "tv")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: ResponsiveLayout.posterSize.height)
                    .foregroundColor(.gray)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(12)
            }
            
            // TV Show Name
            Text(show.name)
                .font(.title2)
                .bold()
                .lineLimit(1)
                .padding(.horizontal, 4)
            
            // Rating and Year
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .imageScale(.small)
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", show.voteAverage))
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Text(show.firstAirDate.changeFormat(from: .dashedReversedDateFormat, to: .slashedMonthYearFormat))
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

