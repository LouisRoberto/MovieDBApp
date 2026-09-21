//
//  TvShowDetailView.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import SwiftUI
import Kingfisher

struct TvShowDetailView: View {
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
                // TV Show Poster and Basic Info
                headerSectionTV(tvShowDetail: tvShowDetail)
                
                // Start Airing Date
                infoBadgesTV(tvShowDetail: tvShowDetail)
                
                // TV Show Overview
                overviewSectionTV(tvShowDetail: tvShowDetail)
                
                // TV Show Networks
                networkSection(tvShowDetail: tvShowDetail)
                
                productionSection(tvShowDetail: tvShowDetail)
                
                // TV Show Creators
                if !(tvShowDetail.createdBy?.isEmpty ?? false) {
                    createdBySection(tvShowDetail: tvShowDetail)
                }
                
                if let homepage = tvShowDetail.homepage, !homepage.isEmpty, Helper.shared.isValidURL(homepage) {
                    homepageLink(homePageLink: homepage)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct headerSectionTV: View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Movie Poster
            if let url = tvShowDetail.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 210)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image(systemName: "tv")
                    .frame(width: 140, height: 210)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            
            // Title and Basic Info
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
                
                // Genres
                if let genres = tvShowDetail.genres, !genres.isEmpty {
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
                }
            }
            
            Spacer()
        }
    }
}

struct infoBadgesTV: View {
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
        }
        
        Spacer()
    }
}

struct overviewSectionTV: View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("movie.overview".localized())
                .font(.headline)
            
            if tvShowDetail.overview.count > 0{
                Text(tvShowDetail.overview)
                    .font(.body)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("tv.no_overview".localized())
                    .foregroundColor(.secondary)
            }
            
            
        }
    }
}

struct networkSection: View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("tv.networks".localized())
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tvShowDetail.networks ?? []) { network in
                        networkThumbnail(network: network)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}


struct networkThumbnail: View {
    let network: Network
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let thumbnailURL = network.fullLogoURL {
                    KFImage(thumbnailURL)
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 136)
                        .background(Color.white)
                        .clipped()
                } else {
                    Color.gray
                        .frame(width: 240, height: 136)
                }
            }
            .frame(width: 240, height: 136)
            .cornerRadius(8)
        }
    }
}

struct productionSection: View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("tv.productions".localized())
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(tvShowDetail.productionCompanies ?? []) { production in
                        productionThumbnail(productionCompany: production)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}


struct productionThumbnail: View {
    let productionCompany: ProductionCompany
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let thumbnailURL = productionCompany.fullLogoURL {
                    KFImage(thumbnailURL)
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 240, height: 136)
                        .background(Color.white)
                        .clipped()
                } else {
                    Color.gray
                        .frame(width: 240, height: 136)
                }
            }
            .frame(width: 240, height: 136)
            .cornerRadius(8)
        }
    }
}

struct createdBySection: View {
    let tvShowDetail: TvShowDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("tv.created.by".localized())
                .font(.headline)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(tvShowDetail.createdBy ?? []) { createdB in
                        createdByThumbnail(createdBy: createdB)
                    }
                }
                .padding(.vertical, 8)
            }
        }
    }
}

struct createdByThumbnail: View {
    let createdBy: CreatedBy
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                if let thumbnailURL = createdBy.fullProfileURL {
                    KFImage(thumbnailURL)
                        .resizable()
                        .placeholder {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 150)
                        .clipped()
                } else {
                    Color.gray
                        .frame(width: 100, height: 150)
                }
            }
            .frame(width: 100, height: 150)
            .cornerRadius(4)
            
            Text(createdBy.name)
                .font(.footnote)
                .lineLimit(2)
                .frame(width: 100, height: 30, alignment: .leading)
        }
    }
}
