//
//  Date+Extensions.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 25.05.2025.
//
import Foundation

extension Date {
    func formattedDescription(for period: Period) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US")
        
        switch period {
        case .week, .month:
            formatter.dateFormat = "EEEE, MMM d, yyyy"
        case .year:
            formatter.dateFormat = "MMMM, yyyy"
        }
        
        return formatter.string(from: self)
    }
    
    static func getDateFrom(locationX: CGFloat, chartWidth: CGFloat, minDate: Date, maxDate: Date) -> Date? {
        guard chartWidth > 0 else { return nil }
        
        let clampedPercent = Swift.max(0, Swift.min(locationX / chartWidth, 1))
        let range = maxDate.timeIntervalSince1970 - minDate.timeIntervalSince1970
        let selectedTime = minDate.timeIntervalSince1970 + range * Double(clampedPercent)
        return Date(timeIntervalSince1970: selectedTime)
    }
}
