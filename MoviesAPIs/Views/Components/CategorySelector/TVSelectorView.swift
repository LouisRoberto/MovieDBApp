//
//  TVSelectorView.swift
//  MoviesAPIs
//
//  Created by mac on 18/5/25.
//

import SwiftUI

struct TVSelectorView: View {

    let categories: [TVCategory]
    @Binding var selectedCategory: TVCategory
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    TVCategoryPill(
                        category: category,
                        isSelected: selectedCategory == category
                    )
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedCategory = category
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
}

struct TVCategoryPill: View {
    let category: TVCategory
    let isSelected: Bool
    
    var body: some View {
        Text(category.title)
            .font(.system(size: 16, weight: .medium))
            .foregroundColor(isSelected ? .black : .primary)
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

