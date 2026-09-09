//
//  MainTabView.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        if ResponsiveLayout.isIPad {
            // iPad: Use split view for better experience
            NavigationSplitView(columnVisibility: $columnVisibility) {
                sidebar.navigationSplitViewColumnWidth(min: 150, ideal: 180, max: 220)
            } detail: {
                detailView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        } else {
            // iPhone: Use tab view
            TabView(selection: $selectedTab) {
                MovieListView()
                    .tabItem {
                        Label("movies.title".localized(), systemImage: "film")
                    }
                    .tag(0)
                
                TVShowListView()
                    .tabItem {
                        Label("tv.title".localized(), systemImage: "tv")
                    }
                    .tag(1)
            }
            .accentColor(.blue)
        }
    }
    
    @ViewBuilder
    private var sidebar: some View {
        List {
            Label("movies.title".localized(), systemImage: "film")
                .tag(0)
                .onTapGesture {
                    selectedTab = 0
                }
                .listRowInsets(EdgeInsets())
            
            Label("tv.title".localized(), systemImage: "tv")
                .tag(1)
                .onTapGesture {
                    selectedTab = 1
                }
                .listRowInsets(EdgeInsets())
        }
        .listStyle(.sidebar)
    }
    
    @ViewBuilder
    private var detailView: some View {
        if selectedTab == 0 {
            MovieListView()
        } else {
            TVShowListView()
        }
    }
}
