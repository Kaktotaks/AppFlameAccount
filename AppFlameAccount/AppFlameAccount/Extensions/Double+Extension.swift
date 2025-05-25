//
//  Double+Extension.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 25.05.2025.
//
import Foundation

extension Double {
    var formattedAmount: String {
        let isInteger = self.truncatingRemainder(dividingBy: 1) == 0

        let formatted = isInteger
            ? String(format: "%.0f", self)
            : String(format: "%.2f", self)

        // Додаємо роздільник тисяч вручну
        let parts = formatted.split(separator: ".")
        let intPart = parts[0]
        let decimalPart = parts.count > 1 ? parts[1] : ""

        // Роздільник тисяч
        let number = Int(intPart) ?? 0
        let numberFormatter = NumberFormatter()
        numberFormatter.groupingSeparator = " "
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        let formattedInt = numberFormatter.string(from: NSNumber(value: number)) ?? "\(intPart)"

        return decimalPart.isEmpty ? formattedInt : "\(formattedInt).\(decimalPart)"
    }
}
