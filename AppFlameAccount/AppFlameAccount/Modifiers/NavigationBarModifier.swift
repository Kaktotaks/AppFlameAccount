//
//  NavigationBarModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 24.05.2025.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(title)
    }
}

extension View {
    func navigationDetailsModifier(title: String) -> some View {
        self.modifier(NavigationBarModifier(title: title))
    }
}
