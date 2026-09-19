//
//  VideoPlayerView.swift
//  MoviesAPIs
//
//  Created by mac on 9/9/26.
//

import SwiftUI
import YouTubePlayerKit

struct VideoPlayerView: View {
    
    let videoID: String
    @StateObject private var youTubePlayer: YouTubePlayer

    init(videoID: String) {
        self.videoID = videoID
        // Initialize the player with the correct source API using the video id
        _youTubePlayer = StateObject(wrappedValue: YouTubePlayer(source: .video(id: videoID)))
    }
    
    var body: some View {
        VStack {
            YouTubePlayerView(youTubePlayer)
                .frame(height: 400)
                .cornerRadius(12)
                .padding()
        }
    }
}

#Preview {
    VideoPlayerView(videoID: "dQw4w9WgXcQ")
}
