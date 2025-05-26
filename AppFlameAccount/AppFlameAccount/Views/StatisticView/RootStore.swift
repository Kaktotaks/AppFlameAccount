
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
        
        func filteredAccounts(entries: [AccountModel], selectedDate: Date) -> [String] {
            entries
                .filter { $0.date <= selectedDate }
                .map(\.name)
        }
        
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
            let now = entries.map(\.date).max() ?? Date()

            switch selectedPeriod {
            case .week:
                let start = calendar.date(byAdding: .day, value: -6, to: now) ?? now
                return entries.filter { $0.date >= start && $0.date <= now }

            case .month:
                let lastMonth = calendar.component(.month, from: now)
                let lastYear = calendar.component(.year, from: now)
                return entries.filter {
                    let comp = calendar.dateComponents([.year, .month], from: $0.date)
                    return comp.year == lastYear && comp.month == lastMonth
                }

            case .year:
                let lastYear = calendar.component(.year, from: now)
                return entries.filter {
                    calendar.component(.year, from: $0.date) == lastYear
                }
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
