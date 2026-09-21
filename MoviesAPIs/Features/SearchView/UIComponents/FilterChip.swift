//
//  FilterChip.swift
//  MoviesAPIs
//
//  Created by mac on 21/9/26.
//

import SwiftUI

struct FilterChip: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .black : .primary)
                
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(isSelected ? .black : .primary)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(
                Capsule()
                    .fill(isSelected ? Color.yellow : Color(.secondarySystemBackground))
            )
            .overlay(
                Capsule()
                    .stroke(Color(.separator), lineWidth: isSelected ? 0 : 0.5)
            )
        }
    }
}
