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
    let selectedDate: Date

    var body: some View {
        VStack {
            Chart(entries) { entry in
                LineMark(
                    x: .value("Date", entry.date),
                    y: .value("Amount", entry.amount)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(entry.date == selectedDate ? .red : .blue)
            }
        }
    }
}
