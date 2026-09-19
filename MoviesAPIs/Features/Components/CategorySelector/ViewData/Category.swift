//
//  Category.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import Foundation

protocol Category: Hashable, CaseIterable {
    var title: String { get }
}

extension Category where Self: RawRepresentable, Self.RawValue == String {
    var title: String {
        return rawValue.localized()
    }
}
