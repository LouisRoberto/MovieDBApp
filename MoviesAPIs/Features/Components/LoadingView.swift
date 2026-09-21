//
//  LoadingView.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI

struct LoadingView: View {
    let title: String
    
    var body: some View {
        VStack {
            Spacer()
            ProgressView()
                .scaleEffect(1.5)
            Text(title)
                .foregroundColor(.secondary)
                .padding(.top, 12)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView(title: "Searching...")
}
