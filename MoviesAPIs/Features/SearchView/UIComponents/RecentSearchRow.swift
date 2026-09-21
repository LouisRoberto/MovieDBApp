//
//  RecentSearchRow.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI

struct RecentSearchRow: View {
    let search: String
    let onTap: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "clock.arrow.circlepath")
                .foregroundColor(.secondary)
                .frame(width: 24)
            
            Text(search)
                .foregroundColor(.primary)
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .contentShape(Rectangle())
        .onTapGesture(perform: onTap)
    }
}
