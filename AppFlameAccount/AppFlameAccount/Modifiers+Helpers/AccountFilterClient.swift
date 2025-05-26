//
//  AccountFilterClient.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 25.05.2025.
//

import Foundation
import ComposableArchitecture

struct EntryFilterClient {
    var filteredEntries: (_ entries: [AccountModel], _ period: Period) -> [AccountModel]
    var filteredAccounts: (_ entries: [AccountModel], _ period: Period, _ selectedDate: Date) -> [AccountModel]
}

extension EntryFilterClient {
    static let live: EntryFilterClient = {
        let filteredEntries: (_ entries: [AccountModel], _ period: Period) -> [AccountModel] = { entries, period in
            let sorted = entries.sorted { $0.date < $1.date }
            guard let latestDate = sorted.last?.date else { return [] }

            let calendar = Calendar.current
            switch period {
            case .week:
                let start = calendar.date(byAdding: .day, value: -6, to: latestDate) ?? latestDate
                return sorted.filter { $0.date >= start && $0.date <= latestDate }
            case .month:
                let start = calendar.date(byAdding: .month, value: -1, to: latestDate) ?? latestDate
                return sorted.filter { $0.date >= start && $0.date <= latestDate }
            case .year:
                return sorted
            }
        }

        let filteredAccounts: (_ entries: [AccountModel], _ period: Period, _ selectedDate: Date) -> [AccountModel] = { entries, period, selectedDate in
            let filtered = filteredEntries(entries, period)
            return filtered.filter { $0.date <= selectedDate }
        }

        return EntryFilterClient(
            filteredEntries: filteredEntries,
            filteredAccounts: filteredAccounts
        )
    }()
}

private enum EntryFilterClientKey: DependencyKey {
    static let liveValue = EntryFilterClient.live
}

extension DependencyValues {
    var entryFilterClient: EntryFilterClient {
        get { self[EntryFilterClientKey.self] }
        set { self[EntryFilterClientKey.self] = newValue }
    }
}
