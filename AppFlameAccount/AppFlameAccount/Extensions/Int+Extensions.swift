//
//  Int+Extensions.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 26.05.2025.
//

import Foundation

extension Int {
    func formattedWithGroupingSeparator(separator: String = " ") -> String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = separator
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
