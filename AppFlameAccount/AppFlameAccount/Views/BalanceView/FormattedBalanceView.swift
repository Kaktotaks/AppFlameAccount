//
//  FormattedBalanceView.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 25.05.2025.
//

import SwiftUI

struct FormattedBalanceView: View {
    let amount: Double
    let textStyle: TextStyle
    var currencySymbol: String = "$"
    var balanceType: BalanceType = .standart
    
    var body: some View {
        let formatted = FormattedAmountParts(amount: amount)
        
        switch balanceType {
        case .standart:
            Text("\(formatted.prefix)\(currencySymbol)\(formatted.main)\(formatted.decimal.isEmpty || formatted.decimal == "00" ? "" : ".\(formatted.decimal)")")
                .textStyle(textStyle)
                .lineLimit(1)
            
        case .statistic, .details:
            HStack(alignment: .bottom, spacing: 0) {
                if formatted.isNegative {
                    Text("-")
                }
                Text(currencySymbol)
                    .opacity(balanceType == .details ? 1 : 0.6)
                Text(formatted.main)
                if !formatted.decimal.isEmpty && formatted.decimal != "00" {
                    Text(".\(formatted.decimal)")
                        .textStyle(balanceType == .details ? .detailsAccountAmmountDeclima : .mainBalanceDeclima)
                        .baselineOffset(2)
                        .padding(2)
                }
            }
            .textStyle(textStyle)
        }
    }
}
