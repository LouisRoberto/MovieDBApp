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
            LoadingView(title: "common.loading".localized())
            
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
