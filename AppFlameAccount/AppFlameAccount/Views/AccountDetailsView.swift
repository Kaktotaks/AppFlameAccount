//
//  AccountDetailsView.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI
import ComposableArchitecture

@Reducer
struct AccountDetailsStore {
    struct State: Equatable {
        var foo = ""
        var model: AccountModel
    }
    
    enum Action {
        case onAppear
        case loadMockData
        
        case delegate(Delegate)
        enum Delegate {
            case didShowAccountDetailsStore
            case navigateBack
        }
        
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .loadMockData:
                return .none
            case .delegate(_):
                return .none
            }
        }
    }
}

struct AccountDetailsView: View {
    let store: StoreOf<AccountDetailsStore>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .center, spacing: 24) {
                    Image(.bankLogo)
                        .frame(width: 80, height: 80)
                        .padding(.horizontal, 16)
                    
                Text(viewStore.model.name)
                            .font(.subheadline)
                Text(viewStore.model.description)
                            .font(.caption)
                    
                Text("$\(viewStore.model.amount)")
                        .font(.subheadline)
                        .padding(.trailing, 16)
            }
            .setupBackButton() {
                viewStore.send(.delegate(.navigateBack))
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Details")
        }
    }
}
