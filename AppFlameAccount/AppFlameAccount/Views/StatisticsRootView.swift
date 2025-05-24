//
//  StatisticsRootView.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI
import ComposableArchitecture
import Charts

struct StatisticsRootView: View {
    @State var store: StoreOf<RootStore>
    @State private var bottomSheetPosition: BottomSheetPosition = .middle
    
    enum BottomSheetPosition: CGFloat, CaseIterable {
        case top = 0.1
        case middle = 0.5
        
        var springAnimation: Animation {
            switch self {
            case .top:
                return .interpolatingSpring(
                    mass: 0.5,
                    stiffness: 300,
                    damping: 20,
                    initialVelocity: 0
                )
            case .middle:
                return .interpolatingSpring(
                    mass: 0.8,
                    stiffness: 250,
                    damping: 25,
                    initialVelocity: 0
                )
            }
        }
    }
    
    var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path)
        ) {
            WithViewStore(self.store, observe: { $0 }) { viewStore in
                ZStack(alignment: .top) {
                    ChartView(entries: filteredEntries(viewStore: viewStore), selectedDate: viewStore.selectedDate)
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                    
                    BottomSheetView(viewStore, position: $bottomSheetPosition)
                }
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
    private func BottomSheetView(_ viewStore: ViewStoreOf<RootStore>, position: Binding<BottomSheetPosition>) -> some View {
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
                                let dragPercentage = value.translation.height / geometry.size.height
                                withAnimation(position.wrappedValue.springAnimation) {
                                    if dragPercentage > 0.3 {
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
                .listStyle(.plain)
            }
            .background(
                RoundedRectangle(cornerRadius: 32, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: -2)
            )
            .ignoresSafeArea()
            .frame(height: geometry.size.height * (position.wrappedValue == .middle ? 0.5 : 0.9))
            .frame(maxHeight: .infinity, alignment: .bottom)
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
