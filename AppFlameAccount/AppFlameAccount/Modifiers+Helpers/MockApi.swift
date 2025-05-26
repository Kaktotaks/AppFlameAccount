//
//  MockApi.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 26.05.2025.
//

import SwiftUI
import ComposableArchitecture

struct MockApiClient {
    var loadAccounts: @Sendable () async throws -> [AccountModel]
}

enum MockApiClientKey: DependencyKey {
    static let liveValue = MockApiClient(
        loadAccounts: {
            try await Task.sleep(nanoseconds: 2_500_000_000)
            return CSVLoader.loadAccountData(from: .accounts)
        }
    )
}

extension DependencyValues {
    var mockApiClient: MockApiClient {
        get { self[MockApiClientKey.self] }
        set { self[MockApiClientKey.self] = newValue }
    }
}
