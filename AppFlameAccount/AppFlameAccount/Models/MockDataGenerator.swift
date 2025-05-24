//
//  MockDataGenerator.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import Foundation

enum MockDataGenerator {
    static func generate() -> [AccountModel] {
        let calendar = Calendar.current
        let now = Date()
        return (50..<365).map { offset in
            let date = calendar.date(byAdding: .day, value: -offset, to: now) ?? now
            return AccountModel(date: date, amount: Int.random(in: 50...1000), name: "Account \(Int.random(in: 1...3))", description: "Account Description")
        }
    }
}
