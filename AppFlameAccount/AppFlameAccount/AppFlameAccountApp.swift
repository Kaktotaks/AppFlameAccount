//
//  AppFlameAccountApp.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct AppFlameAccountApp: App {
    let store = Store(
        initialState: RootStore.State(),
        reducer: { RootStore()}
    )
    
    var body: some Scene {
        WindowGroup {
            StatisticsRootView(store: store)
                .preferredColorScheme(.light)
        }
    }
}
