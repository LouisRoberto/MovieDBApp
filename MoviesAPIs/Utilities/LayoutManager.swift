//
//  LayoutManager.swift
//  MoviesAPIs
//
//  Created by mac on 30/8/26.
//

import SwiftUI

enum DeviceType {
    case iPhone
    case iPad
    case mac
    
    static var current: DeviceType {
        #if targetEnvironment(macCatalyst)
        return .mac
        #else
        if UIDevice.current.userInterfaceIdiom == .pad {
            return .iPad
        } else {
            return .iPhone
        }
        #endif
    }
}

struct ResponsiveLayout {
    static var isIPad: Bool {
        DeviceType.current == .iPad
    }
    
    static var isIPhone: Bool {
        DeviceType.current == .iPhone
    }
    
    static var gridColumns: [GridItem] {
        if isIPad {
            // iPad: 3-4 columns depending on orientation
            return Array(repeating: GridItem(.flexible(), spacing: 16), count: 4)
        } else {
            // iPhone: 2 columns
            return Array(repeating: GridItem(.flexible(), spacing: 12), count: 2)
        }
    }
    
    static var thumbnailSize: CGSize {
        if isIPad {
            return CGSize(width: 300, height: 169) // 16:9 ratio
        } else {
            return CGSize(width: 220, height: 124)
        }
    }
    
    static var posterSize: CGSize {
        if isIPad {
            return CGSize(width: 200, height: 300)
        } else {
            return CGSize(width: 120, height: 180)
        }
    }
}
