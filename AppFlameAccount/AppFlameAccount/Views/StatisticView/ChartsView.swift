//
//  ChartsView.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI
import Charts

struct ChartView: View {
    let entries: [AccountModel]
    @State var selectedEntry: AccountModel?
    let onSelect: (AccountModel) -> Void
    
    var body: some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color("chartLineColor").opacity(0.5),
                Color("chartLineColor").opacity(0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        
        let minDate = entries.map(\.date).min() ?? Date()
        let maxDate = entries.map(\.date).max() ?? Date()

        let selectedDate = selectedEntry?.date

        let beforeEntries = selectedDate == nil
            ? entries
            : entries.filter { $0.date <= selectedDate! }

        let afterEntries = selectedDate == nil
            ? []
            : entries.filter { $0.date > selectedDate! }

        ZStack {
            Chart {
                ForEach(beforeEntries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Amount", entry.amount)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(Color("chartLineColor").opacity(1))

                    AreaMark(
                        x: .value("Date", entry.date),
                        y: .value("Amount", entry.amount)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(gradient.opacity(1))
                }

                ForEach(afterEntries) { entry in
                    LineMark(
                        x: .value("Date", entry.date),
                        y: .value("Amount", entry.amount)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(Color("chartLineColor").opacity(0.4))

                    AreaMark(
                        x: .value("Date", entry.date),
                        y: .value("Amount", entry.amount)
                    )
                    .interpolationMethod(.cardinal)
                    .foregroundStyle(gradient.opacity(0.4))
                }

                // horizontal white line
                if let selected = selectedEntry {
                    RuleMark(x: .value("Selected", selected.date))
                        .lineStyle(StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.white)
                }

                // Зелена крапка
                if let selected = selectedEntry {
                    PointMark(
                        x: .value("Date", selected.date),
                        y: .value("Amount", selected.amount)
                    )
                    .symbolSize(50)
                    .foregroundStyle(Color("chartLineColor"))
                }
                
            }
            .chartXScale(domain: minDate ... maxDate)
            .chartYAxis { }
            .chartXAxis { }
            .chartLegend(.hidden)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        // Finding closest point
                        if let date = Date.getDateFrom(locationX: value.location.x, chartWidth: UIScreen.main.bounds.width, minDate: minDate, maxDate: maxDate) {
                            let nearest = entries.min(by: {
                                abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) <
                                abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970)
                            })
                            selectedEntry = nearest
                            onSelect(nearest!)
                        }
                    }
            )
            
            GeometryReader { geo in
                let chartWidth = geo.size.width
                let spacing = chartWidth / CGFloat(entries.count)
                
                HStack(spacing: spacing) {
                    ForEach(entries.indices, id: \.self) { _ in
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 2, height: 8)
                    }
                }
                .frame(height: geo.size.height, alignment: .bottom)
            }
        }
    }
}
