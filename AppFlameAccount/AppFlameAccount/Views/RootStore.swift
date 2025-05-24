
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
    
    @Reducer(state: .equatable)
    enum Destination {
        case accountDetails(AccountDetailsStore)
    }
    
    struct State: Equatable {
        var path = StackState<Destination.State>()
        var selectedPeriod: Period = .week
        var selectedDate: Date = Date()
        var entries: [AccountModel] = [.init(date: .now, amount: 100, name: "Account", description: "Account descriprion"), .init(date: .now, amount: 101, name: "Account1", description: "Account1 descriprion"), .init(date: .now, amount: 102, name: "Account2", description: "Account2 descriprion")]
        
        func filteredAccounts(entries: [AccountModel], selectedDate: Date) -> [String] {
            entries
                .filter { $0.date <= selectedDate }
                .map(\.name)
        }
    }
    
    enum Action {
        case showDetailsView(model: AccountModel)
        case path(StackAction<Destination.State, Destination.Action>)
        
        case loadMockData
        case selectPeriod(Period)
        case selectDate(Date)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadMockData:
                state.entries = MockDataGenerator.generate()
                state.selectedDate = state.entries.sorted(by: { $0.date < $1.date }).last?.date ?? Date()
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
