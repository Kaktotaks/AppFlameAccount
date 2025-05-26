//
//  FadeTransitionModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 26.05.2025.
//

import SwiftUI

struct FadeTransitionModifier<Value: Equatable>: ViewModifier {
    let value: Value
    let duration: Double

    func body(content: Content) -> some View {
        content
            .transition(.opacity)
            .animation(.easeInOut(duration: duration), value: value)
    }
}

extension View {
    func fadeTransition<Value: Equatable>(when value: Value, duration: Double = 0.4) -> some View {
        self.modifier(FadeTransitionModifier(value: value, duration: duration))
    }
}
