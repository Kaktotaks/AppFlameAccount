
//
//  RootStore.swift
//  TitleOnboarding
//
//  Created by Леонід Шевченко on 27.02.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct RootStore {
    @Dependency(\.mockApiClient) var mockApiClient
    
    @Reducer(state: .equatable)
    enum Destination {
        case accountDetails(AccountDetailsStore)
    }
    
    struct State: Equatable {
        var path = StackState<Destination.State>()
        var entries: [AccountModel] = []
        let title = "Statistics"
        var isDataLoaded: Bool = false
        
        var selectedPeriod: Period = .week
        var selectedDate: Date = .now
        var selectedAccount: AccountModel? = nil

        var currentAccount: AccountModel? {
            selectedAccount ?? filteredEntries
                .filter { Calendar.current.isDate($0.date, inSameDayAs: selectedDate) }
                .first
        }

        var filteredEntries: [AccountModel] {
            let calendar = Calendar.current
            let sortedEntries = entries.sorted { $0.date < $1.date }

            guard let minDate = sortedEntries.first?.date,
                  let maxDate = sortedEntries.last?.date else { return [] }

            let maxComponents = calendar.dateComponents([.year, .month], from: maxDate)

            switch selectedPeriod {
            case .week:
                let lastMonthEntries = entries.filter {
                    let comps = calendar.dateComponents([.year, .month], from: $0.date)
                    return comps.year == maxComponents.year && comps.month == maxComponents.month
                }.sorted { $0.date < $1.date }
                return Array(lastMonthEntries.suffix(7))

            case .month:
                return entries.filter {
                    let comps = calendar.dateComponents([.year, .month], from: $0.date)
                    return comps.year == maxComponents.year && comps.month == maxComponents.month
                }

            case .year:
                return entries.filter { $0.date >= minDate && $0.date <= maxDate }
            }
        }
    }
    
    enum Action {
        case showDetailsView(model: AccountModel)
        case path(StackAction<Destination.State, Destination.Action>)
        
        case loadMockData
        case loadMockDataResponse([AccountModel])
        
        case selectPeriod(Period)
        case selectDate(Date)
        case selectAccount(AccountModel)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .selectAccount(let account):
                state.selectedAccount = account
                return .none
            case .loadMockData:
                guard !state.isDataLoaded else { return .none }
                return .run { send in
                    let entries = try await mockApiClient.loadAccounts()
                    await send(.loadMockDataResponse(entries))
                }
                
            case .loadMockDataResponse(let entries):
                state.entries = entries
                state.selectedDate = entries.sorted(by: { $0.date < $1.date }).last?.date ?? Date()
                state.isDataLoaded = true
                return .none
                
            case .selectPeriod(let period):
                state.selectedPeriod = period
                return .none
                
            case .selectDate(let date):
                state.selectedDate = date
                return .none
            case .showDetailsView(let model):
                state.path.append(.accountDetails(.init(model: model)))
                return .none
            case .path(.element(id: _, action: .accountDetails(.delegate(.navigateBack)))):
                state.path.popLast()
                return .none
            case .path(_):
                return .none
            }
        }
        .forEach(\.path, action: \.path)
    }
}
