//
//  View+hidekeyboard.swift
//  MoviesAPIs
//
//  Created by mac on 19/9/26.
//

import SwiftUI

#if canImport(UIKit)
public extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
