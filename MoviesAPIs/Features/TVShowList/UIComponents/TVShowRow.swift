//
//  TVShowRow.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI
import Kingfisher

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
