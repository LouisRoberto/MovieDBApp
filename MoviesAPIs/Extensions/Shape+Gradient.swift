//
//  Shape.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI

extension Shape {
    func strokeWithGradient(colors: [Color], startPoint: UnitPoint, endPoint: UnitPoint, lineWidth: CGFloat) -> some View {
        self.stroke(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            ),
            lineWidth: 1
        )
    }
}
