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
    var store: StoreOf<RootStore>
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
                    .fadeTransition(when: viewStore.isDataLoaded)
                }
                .navigationBarModifier(title: viewStore.title, color: .white)
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
    
    
    // MARK: - View builders
    @ViewBuilder
    private func MainContentView(_ viewStore: ViewStoreOf<RootStore>, proxy: GeometryProxy) -> some View {
        let amount = viewStore.currentAccount?.amount ?? 0
        VStack {
            MainAmountView(amount: amount, isNegative: amount.isNegative, date: (viewStore.selectedAccount?.date ?? viewStore.selectedDate).formattedDescription(for: viewStore.selectedPeriod))
                .padding(.horizontal, 32)
            
            ZStack {
                if viewStore.isDataLoaded {
                    ChartView(
                        entries: viewStore.filteredEntries,
                        selectedEntry: viewStore.selectedAccount
                    ) { selected in
                        viewStore.send(.selectAccount(selected))
                    }
                } else {
                    ChartSkeletonView()
                }
            }
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
                
                
                ZStack {
                    if viewStore.isDataLoaded {
                        List(viewStore.filteredEntries.sorted(by: { $0.date > $1.date })) { account in
                            AccountViewCell(
                                name: account.name,
                                description: account.description,
                                amount: account.amount
                            ) {
                                viewStore.send(.showDetailsView(model: account))
                            }
                            .listRowInsets(EdgeInsets())
                        }
                        .refreshable {
                                viewStore.send(.refreshData)
                            }
                    } else {
                        List(0..<5, id: \.self) { _ in
                            AccountViewSkeletonCell()
                                .listRowInsets(EdgeInsets())
                        }
                    }
                }
                .listStyle(.plain)
                .padding(.bottom, position.wrappedValue == .top ? geometry.safeAreaInsets.bottom + 60 : 20)
            }
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .frame(height: max(0, position.wrappedValue == .top
                               ? geometry.size.height + geometry.safeAreaInsets.top
                               : geometry.size.height * 0.5))
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.all, edges: .bottom)
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
}

private struct MainAmountView: View {
    let amount: Double
    let isNegative: Bool
    let date: String
    
    var body: some View {
        VStack(spacing: 4) {
            FormattedBalanceView(amount: amount, textStyle: .mainBalance, balanceType: .statistic)
            
            Text(date)
                .textStyle(.dateDescription)
                .textStyle(.mainBalance)
                .opacity(0.6)
        }
    }
}
