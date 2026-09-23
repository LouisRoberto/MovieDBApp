//
//  PersonDetailView.swift
//  MoviesAPIs
//
//  Created by mac on 22/9/26.
//

import SwiftUI
import Kingfisher

struct PersonDetailView: View {
    
    let personId: Int
    let personName: String
    
    @StateObject private var viewModel = PersonDetailViewModel()
    
    var body: some View {
        ScrollView {
            if viewModel.isLoading {
                LoadingView(title: "common.loading".localized())
            } else if let error = viewModel.error {
                ErrorView(error: error)
            } else if let personDetail = viewModel.personDetail {
                personContent(for: personDetail)
            }
        }
        .navigationTitle(personName)
        .navigationBarTitleDisplayMode(.inline)
        .frame(maxWidth: .infinity)
        .refreshable {
            Task {
                await viewModel.fetchPersonInfos(personId: personId)
            }
        }
        .task {
            await viewModel.fetchPersonInfos(personId: personId)
        }
    }
    
    @ViewBuilder
    private func personContent(for person: PersonDetail) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Person Poster and Basic Info
                headerSectionPerson(personDetail: person)
                
                // Person Overview
                if person.biography.count > 0 {
                    biographySection(person: person)
                }
                
                if let homepage = person.homepage, !homepage.isEmpty, Helper.shared.isValidURL(homepage) {
                    homepageLink(homePageLink: homepage)
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct headerSectionPerson: View {
    let personDetail: PersonDetail
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Movie Poster
            if let url = personDetail.fullPosterURL {
                KFImage(url)
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 210)
                    .cornerRadius(8)
                    .shadow(radius: 4)
            } else {
                Image(systemName: "person")
                    .frame(width: 140, height: 210)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }
            
            // Title and Basic Info
            VStack(alignment: .leading, spacing: 8) {
                Text(personDetail.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("\("person.department".localized()) \(personDetail.knownFor)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\("person.popularity".localized()) \(String(format: "%.1f", personDetail.popularity))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("\("person.gender".localized()) \(personDetail.gender.displayName)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if personDetail.birthdayDisplayText.count > 0 {
                    Text("\("person.birthday".localized()) \(personDetail.birthdayDisplayText)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if let placeOfBirth = personDetail.placeOfBirth {
                    Text("\("person.Birth.place".localized()) \(placeOfBirth)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
            }
            
            Spacer()
        }
    }
}

struct biographySection: View {
    let person: PersonDetail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("person.biography".localized())
                .font(.headline)
            
            Text(person.biography)
                .font(.body)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
