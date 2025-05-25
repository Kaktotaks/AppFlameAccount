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
    
    var body: some View {
        let gradient = LinearGradient(
            gradient: Gradient(colors: [
                Color("chartLineColor"),
                Color("chartLineColor").opacity(0)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )

        let minDate = entries.map(\.date).min() ?? Date()
        let maxDate = entries.map(\.date).max() ?? Date()

        Chart {
            // Лінія (без символів)
            ForEach(entries) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Amount", entry.amount)
                )
                .interpolationMethod(.cardinal)
            }

            // AreaMark з градієнтом
            ForEach(entries) { entry in
                AreaMark(
                    x: .value("Date", entry.date),
                    y: .value("Amount", entry.amount)
                )
                .interpolationMethod(.cardinal)
                .foregroundStyle(gradient)
            }

            // Вертикальні короткі лінії (індикатори вибору)
            ForEach(entries) { entry in
                RuleMark(x: .value("Date", entry.date))
                    .lineStyle(StrokeStyle(lineWidth: 1))
                    .foregroundStyle(Color.white.opacity(0.2))
            }
        }
        .chartXScale(domain: minDate ... maxDate)
        .chartYAxis {
            AxisMarks(position: .leading)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { value in
//                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.day().month(.abbreviated))
            }
        }
        .chartLegend(.hidden)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
    }
}
