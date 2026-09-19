//
//  PlaceholderGradientView.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI

struct PlaceholderGradientView: View {
    let gradientColor = Color.gray
    var body: some View {
        LinearGradient(
            gradient: Gradient(stops: [
                .init(color: gradientColor.opacity(0.15), location: -1.0467),
                .init(color: gradientColor.opacity(0.3), location: -0.5391),
                .init(color: gradientColor.opacity(0.15), location: -0.0314)
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
