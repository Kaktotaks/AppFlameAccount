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

                if let selected = selectedEntry {
                    RuleMark(x: .value("Selected", selected.date))
                        .lineStyle(StrokeStyle(lineWidth: 2))
                        .foregroundStyle(Color.white)

                    PointMark(
                        x: .value("Date", selected.date),
                        y: .value("Amount", selected.amount)
                    )
                    .symbolSize(70)
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
                        if let date = Date.getDateFrom(
                            locationX: value.location.x,
                            chartWidth: UIScreen.main.bounds.width,
                            minDate: minDate,
                            maxDate: maxDate
                        ) {
                            if let nearest = entries.min(by: {
                                abs($0.date.timeIntervalSince1970 - date.timeIntervalSince1970) <
                                abs($1.date.timeIntervalSince1970 - date.timeIntervalSince1970)
                            }) {
                                selectedEntry = nearest
                                onSelect(nearest)
                            }
                        }
                    }
            )

            GeometryReader { geo in
                let chartWidth = geo.size.width
                let spacing = chartWidth / CGFloat(max(entries.count - 1, 1))

                ZStack(alignment: .bottomLeading) {
                    ForEach(entries.indices, id: \.self) { index in
                        Rectangle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 2, height: 8)
                            .offset(x: CGFloat(index) * spacing)
                    }
                }
                .frame(width: chartWidth, height: geo.size.height, alignment: .bottomLeading)
            }
        }
    }
}

struct ChartSkeletonView: View {
    @State private var phase: CGFloat = 0
    let timer = Timer.publish(every: 0.016, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            Canvas { context, size in
                let path = makeWavePath(width: size.width, height: size.height, phase: phase)
                context.stroke(path, with: .color(.white.opacity(0.3)), lineWidth: 3)
            }
        }
        .onReceive(timer) { _ in
            phase += 0.05
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }

    private func makeWavePath(width: CGFloat, height: CGFloat, phase: CGFloat) -> Path {
        var path = Path()
        let amplitude: CGFloat = height * 0.2
        let midHeight = height / 2
        let frequency: CGFloat = 2.0

        path.move(to: CGPoint(x: 0, y: midHeight))

        for x in stride(from: 0, through: width, by: 1) {
            let percent = x / width

            let fade = sin(.pi * percent)

            let angle = (x / width) * frequency * .pi * 2 + phase
            let y = midHeight + sin(angle) * amplitude * fade

            path.addLine(to: CGPoint(x: x, y: y))
        }

        return path
    }
}
