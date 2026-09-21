//
//  TVShowDetailsIpad.swift
//  MoviesAPIs
//
//  Created by mac on 7/9/26.
//

import SwiftUI
import Kingfisher

struct TVShowDetailsIpad: View {
    
    let tvShowId: Int
    let tvShowName: String
    @StateObject private var viewModel = TvShowDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView(title: "Loading...")
            } else if let error = viewModel.error {
                ErrorView(error: error)
            } else if let tvShowDetail = viewModel.tvShowDetail {
                tvShowContent(for: tvShowDetail)
            }
        }
        .navigationTitle(tvShowName)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .refreshable {
            viewModel.fetchTVShowDetails(tvShowId: tvShowId)
        }
        .onAppear {
            if viewModel.tvShowDetail == nil {
                viewModel.fetchTVShowDetails(tvShowId: tvShowId)
            }
        }
    }
    
    @ViewBuilder
    private func tvShowContent(for tvShowDetail: TvShowDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                posterAndTitleTVSection(tvShowDetail: tvShowDetail)
                
                infoBadgesTVIpad(tvShowDetail: tvShowDetail)
                
                overviewSectionTVIpad(tvShowDetail: tvShowDetail)
                
                networkSection(tvShowDetail: tvShowDetail)
                
                productionSection(tvShowDetail: tvShowDetail)
                
                if !(tvShowDetail.createdBy?.isEmpty ?? false) {
                    createdBySection(tvShowDetail: tvShowDetail)
                }
                
                if let homepage = tvShowDetail.homepage, !homepage.isEmpty, Helper.shared.isValidURL(homepage) {
                    homepageLinkIpad(homePageLink: homepage)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct posterAndTitleTVSection:  View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 16) {
                // Poster
                if let url = tvShowDetail.fullPosterURL {
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
                    Text(tvShowDetail.name)
                        .font(.title2)
                        .fontWeight(.bold)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("\("tv.seasons.number".localized()) \(tvShowDetail.numberOfSeasons)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\("tv.type".localized()) \(tvShowDetail.type)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("\("tv.language".localized()) \(tvShowDetail.originalLanguage)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Genres - Now properly positioned below the HStack
            if let genres = tvShowDetail.genres, !genres.isEmpty {
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

struct infoBadgesTVIpad: View {
    
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        HStack(spacing: 16) {
            // Rating
            HStack(spacing: 4) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                
                Text(String(format: "%.1f", tvShowDetail.voteAverage))
                    .fontWeight(.semibold)
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            // Release Date
            HStack(spacing: 4) {
                Image(systemName: "calendar")
                
                Text(tvShowDetail.firstAirDate.changeFormat(from: .dashedReversedDateFormat, to: .slashedDateFormat))
            }
            .padding(8)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            
            Spacer()
        }
    }
}

struct overviewSectionTVIpad: View {
    
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movie.overview".localized())
                .font(.headline)
            
            if tvShowDetail.overview.count > 0 {
                Text(tvShowDetail.overview)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("tv.no_overview".localized())
                    .font(.body)
                    .foregroundColor(.secondary)
            }
        }
    }
}
