//
//  BalanceFormater.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 26.05.2025.
//

import Foundation

enum BalanceType {
    case statistic, standart, details
}

struct FormattedAmountParts {
    let isNegative: Bool
    let prefix: String
    let main: String
    let decimal: Substring

    init(amount: Double) {
        self.isNegative = amount.isNegative
        self.prefix = isNegative ? "-" : ""

        let absValue = abs(amount)
        let isInteger = absValue.truncatingRemainder(dividingBy: 1) == 0
        let formatted = isInteger
            ? String(format: "%.0f", absValue)
            : String(format: "%.2f", absValue)

        let parts = formatted.split(separator: ".")
        let intPart = Int(parts[0]) ?? 0
        self.main = intPart.formattedWithGroupingSeparator()
        self.decimal = parts.count > 1 ? parts[1] : ""
    }
}
