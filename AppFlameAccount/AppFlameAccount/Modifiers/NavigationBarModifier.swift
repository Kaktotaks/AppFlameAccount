//
//  NavigationBarModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 24.05.2025.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var title: String
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
            .foregroundStyle(color)
    }
}

extension View {
    func navigationDetailsModifier(title: String, color: Color = .black) -> some View {
        self.modifier(NavigationBarModifier(title: title, color: color))
    }
}
