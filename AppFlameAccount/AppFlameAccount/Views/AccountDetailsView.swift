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
            VStack(alignment: .center, spacing: 24) {
                    Image(.bankLogo)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .padding(.top, 36)
                    
                VStack(spacing: 4) {
                    Text(viewStore.model.name)
                        .textStyle(.detailsAccountNameTitle)
                    Text(viewStore.model.description)
                        .textStyle(.detailsAccountDescriptionTitle)
                }
                    
                Text("$\(viewStore.model.amount)")
                    .textStyle(.detailsAccountAmmount)
                
                Spacer()
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
