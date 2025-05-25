//
//  StatisticsRootView.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI
import ComposableArchitecture
import Charts

enum BottomSheetPosition {
    case top
    case middle
    
    var springAnimation: Animation {
        switch self {
        case .top:
            return .interpolatingSpring(mass: 0.5, stiffness: 300, damping: 20, initialVelocity: 0)
        case .middle:
            return .interpolatingSpring(mass: 0.8, stiffness: 250, damping: 25, initialVelocity: 0)
        }
    }
}

enum Period: String, CaseIterable, Identifiable {
    case week, month, year
    var id: String { rawValue }
}

struct StatisticsRootView: View {
    @State var store: StoreOf<RootStore>
    @State private var bottomSheetPosition: BottomSheetPosition = .middle
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                GeometryReader { proxy in
                    ZStack(alignment: .top) {
                        MainContentView(viewStore, proxy: proxy)
                        BottomSheetView(viewStore, position: $bottomSheetPosition, mainContentProxy: proxy)
                    }
                }
                .navigationBarModifier(title: "Statistics", color: .white)
                .background(Color("chartSecondaryColor"))
                .onAppear {
                    viewStore.send(.loadMockData)
                }
            }
        } destination: { state in
            switch state.case {
            case .accountDetails(let store):
                AccountDetailsView(store: store)
            }
        }
    }
    
    @ViewBuilder
    private func MainContentView(_ viewStore: ViewStoreOf<RootStore>, proxy: GeometryProxy) -> some View {
        VStack {
            MainAmountView(amount: 17845.32, isNegative: false, description: "Thursday, Jan 13, 2024")
                .padding(.horizontal, 32)
            
            ChartView(entries: filteredEntries(viewStore: viewStore))
                .frame(height: proxy.size.height * 0.2)
                .padding(.top, 32)
            
            PeriodPickerView(viewStore)
                .padding(.top, 24)
            
        }
        .frame(height: proxy.size.height * 0.4)
        .padding(.top, 32)
    }
    
    @ViewBuilder
    private func BottomSheetView(_ viewStore: ViewStoreOf<RootStore>, position: Binding<BottomSheetPosition>, mainContentProxy: GeometryProxy) -> some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 16) {
                Capsule()
                    .fill(Color.gray.opacity(0.4))
                    .frame(width: 54, height: 4)
                    .padding(.top, 8)
                    .padding(.bottom, 4)
                    .frame(maxWidth: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(position.wrappedValue.springAnimation) {
                            position.wrappedValue = position.wrappedValue == .middle ? .top : .middle
                        }
                    }
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                let threshold = geometry.size.height * 0.25
                                withAnimation(position.wrappedValue.springAnimation) {
                                    if value.translation.height > threshold {
                                        position.wrappedValue = .middle
                                    } else {
                                        position.wrappedValue = .top
                                    }
                                }
                            }
                    )
                
                Text("Accounts")
                    .font(.headline)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                
                List(filteredAccounts(viewStore: viewStore)) { account in
                    AccountViewCell(
                        name: account.name,
                        description: account.description,
                        amount: Int(account.amount)
                    ) {
                        viewStore.send(.showDetailsView(model: account))
                    }
                    .listRowInsets(EdgeInsets())
                }
                //                .navigationDetailsModifier(title: "Statistics", color: .white)
                .listStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .frame(height: max(0, position.wrappedValue == .top
                               ? UIScreen.main.bounds.height
                               : geometry.size.height * 0.5))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    // MARK: FUNCS -
    private func filteredEntries(viewStore: ViewStoreOf<RootStore>) -> [AccountModel] {
        let all = viewStore.entries.sorted { $0.date < $1.date }
        let calendar = Calendar.current
        let now = viewStore.entries.map(\.date).max() ?? Date()
        
        switch viewStore.selectedPeriod {
        case .week:
            let start = calendar.date(byAdding: .day, value: -6, to: now) ?? now
            return all.filter { $0.date >= start && $0.date <= now }
        case .month:
            let start = calendar.date(byAdding: .month, value: -1, to: now) ?? now
            return all.filter { $0.date >= start && $0.date <= now }
        case .year:
            return all
        }
    }
    
    private func filteredAccounts(viewStore: ViewStoreOf<RootStore>) -> [AccountModel] {
        filteredEntries(viewStore: viewStore)
            .filter { $0.date <= viewStore.selectedDate }
            .map { entry in
                AccountModel(
                    date: entry.date,
                    amount: entry.amount,
                    name: entry.name,
                    description: entry.description
                )
            }
    }
}

private struct MainAmountView: View {
    let amount: Double
    let isNegative: Bool
    let description: String
    
    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                if isNegative {
                    Text("-")
                }
                Text("$")
                    .textStyle(.mainBalance)
                    .opacity(0.6)
                Text("\(amount)")
                    .lineLimit(0)
                    .textStyle(.mainBalance)
            }
            
            Text(description)
                .textStyle(.dateDescription)
                .textStyle(.mainBalance)
                .opacity(0.6)
        }
    }
}

@ViewBuilder
private func PeriodPickerView(_ viewStore: ViewStoreOf<RootStore>) -> some View {
    HStack(spacing: 12) {
        ForEach(Period.allCases, id: \.self) { period in
            Button {
                viewStore.send(.selectPeriod(period))
            } label: {
                Text(period.rawValue.capitalized)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(viewStore.selectedPeriod == period ? Color.white.opacity(0.15) : Color.clear)
                    )
                    .foregroundColor(.white)
            }
        }
    }
    .padding(.top, 8)
}
