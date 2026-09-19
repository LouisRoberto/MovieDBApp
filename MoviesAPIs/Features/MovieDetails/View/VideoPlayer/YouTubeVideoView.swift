//
//  MovieVideoView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import WebKit
import SwiftUI

struct YouTubeVideoView: UIViewRepresentable {
    
    let videoID: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.mediaTypesRequiringUserActionForPlayback = []
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        let urlString = "https://www.youtube.com/embed/\(videoID)?playsinline=1"
        print("Youtube Video URL : \(urlString)")
        guard let youtubeURL = URL(string: urlString) else { return }
        uiView.load(URLRequest(url: youtubeURL))
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("YouTube loaded")
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("YouTube failed:", error)
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            print("YouTube provisional navigation failed:", error)
        }
    }
}
