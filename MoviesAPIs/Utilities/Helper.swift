//
//  Helper.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation
import SwiftUI

final class Helper {
    
    static let shared = Helper()
    
    private init() {}
    
    func isValidURL(_ string: String) -> Bool {
        guard let url = URL(string: string),
              UIApplication.shared.canOpenURL(url) else {
            return false
        }
        return true
    }
    
    func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    func makeColumns(for width: CGFloat) -> [GridItem] {
        let minimumCardWidth: CGFloat = 180
        let spacing: CGFloat = 24
        
        let availableWidth = width - 48
        
        let numberOfColumns = max(
            1,
            Int(
                (availableWidth + spacing) /
                (minimumCardWidth + spacing)
            )
        )
        
        return Array(
            repeating: GridItem(.flexible(), spacing: spacing),
            count: numberOfColumns
        )
    }
}
