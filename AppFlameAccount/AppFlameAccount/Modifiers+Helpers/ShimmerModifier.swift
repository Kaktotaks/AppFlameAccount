//
//  ShimmerModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 26.05.2025.
//

import SwiftUI

struct ShimmerModifier: ViewModifier {
    var isActive: Bool

    @State private var phase: CGFloat = 0

    func body(content: Content) -> some View {
        if isActive {
            content
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.white.opacity(0.4), .clear]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .rotationEffect(.degrees(30))
                    .offset(x: phase * 300)
                    .mask(content)
                )
                .onAppear {
                    withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                        phase = 1
                    }
                }
        } else {
            content
        }
    }
}

extension View {
    func shimmering(active: Bool = true) -> some View {
        self
            .modifier(ShimmerModifier(isActive: active))
    }
}
