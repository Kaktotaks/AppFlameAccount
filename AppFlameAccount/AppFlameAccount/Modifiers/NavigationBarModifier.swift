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
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(color)
                }
            }
    }
}

extension View {
    func navigationBarModifier(title: String, color: Color = .black) -> some View {
        self.modifier(NavigationBarModifier(title: title, color: color))
    }
}
