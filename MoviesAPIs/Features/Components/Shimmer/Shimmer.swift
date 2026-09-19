//
//  Shimmer.swift
//  MoviesAPIs
//
//  Created by mac on 14/5/25.
//

import SwiftUI

import SwiftUI

public struct Shimmer<S: Shape>: ViewModifier {
    private let min, max: CGFloat
    private let shape: S
    private let animation = Animation.timingCurve(0.8, 0, 0.6, 1, duration: 0.6).delay(0.6).repeatForever(autoreverses: false)
    private let gradient = Gradient(colors: [
        .white.opacity(0),
        .gray.opacity(0.2),
        .white.opacity(0)
    ])
    @State private var isInitialState = true
    @Environment(\.layoutDirection) private var layoutDirection

    /// Initializes his modifier with the shape to clip to and band size
    /// - Parameters:
    ///   - shape: The shape to clip the shimmer effect to.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points, which corresponds to
    /// 30% of the extent of the gradient.
    public init(
        shape: S,
        bandSize: CGFloat = 0.3
    ) {
        self.shape = shape
        // Calculate unit point dimensions beyond the gradient's edges by the band size
        self.min = 0 - bandSize
        self.max = 1 + bandSize
    }

    /// The start unit point of our gradient, adjusting for layout direction.
    var startPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isInitialState ? UnitPoint(x: max, y: 0.5) : UnitPoint(x: 0, y: 0.5)
        } else {
            return isInitialState ? UnitPoint(x: min, y: 0.5) : UnitPoint(x: 1, y: 0.5)
        }
    }

    /// The end unit point of our gradient, adjusting for layout direction.
    var endPoint: UnitPoint {
        if layoutDirection == .rightToLeft {
            return isInitialState ? UnitPoint(x: 1, y: 0.5) : UnitPoint(x: min, y: 0.5)
        } else {
            return isInitialState ? UnitPoint(x: 0, y: 0.5) : UnitPoint(x: max, y: 0.5)
        }
    }

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    LinearGradient(
                        gradient: gradient,
                        startPoint: startPoint,
                        endPoint: endPoint
                    )
                    .blendMode(.screen)
                    .animation(animation, value: isInitialState)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now()) {
                            isInitialState = false
                        }
                    }
                }
                .clipShape(shape)
            )
            .compositingGroup()
    }
}

public extension View {
    /// Adds an animated shimmering effect to any view with a custom shape.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - shape: The shape to clip the shimmer effect to.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points.
    @ViewBuilder func shimmering<S: Shape>(
        active: Bool = true,
        shape: S,
        bandSize: CGFloat = 0.6
    ) -> some View {
        if active {
            modifier(Shimmer(shape: shape, bandSize: bandSize))
        } else {
            self
        }
    }
    
    /// Adds an animated shimmering effect to any view, using a rounded rectangle shape by default.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - bandSize: The size of the animated mask's "band". Defaults to 0.3 unit points.
    @ViewBuilder func shimmering(
        active: Bool = true,
        bandSize: CGFloat = 0.6
    ) -> some View {
        if active {
            modifier(Shimmer(
                shape: RoundedRectangle(cornerRadius: 16),
                bandSize: bandSize
            ))
        } else {
            self
        }
    }

    /// Adds an animated shimmering effect to any view, typically to show that an operation is in progress.
    /// - Parameters:
    ///   - active: Convenience parameter to conditionally enable the effect. Defaults to `true`.
    ///   - duration: The duration of a shimmer cycle in seconds.
    ///   - bounce: Whether to bounce (reverse) the animation back and forth. Defaults to `false`.
    ///   - delay:A delay in seconds. Defaults to `0.25`.
    @available(*, deprecated, message: "Use shimmering(active:bandSize:) instead.")
    @ViewBuilder func shimmering(
        active: Bool = true, duration: Double, bounce: Bool = false, delay: Double = 0.25
    ) -> some View {
        shimmering(
            active: active
        )
    }
}

