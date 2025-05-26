//
//  AccountViewCell.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI

struct AccountViewCell: View {
    let name: String
    let description: String
    let amount: Double
    let onTapGesture: () -> Void
    
    var body: some View {
        Button {
            onTapGesture()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(.bankLogo)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .textStyle(.accountsListTitle)
                        Text(description)
                            .textStyle(.accountListDescriptionTitle)
                    }
                    
                    Spacer()
                    
                    FormattedBalanceView(amount: amount, textStyle: .accountListAmmount)
                        .padding(.trailing, 16)
                }
            }
            .frame(height: 64)
        }
    }
}


#Preview {
    AccountViewCell(name: "AccountName", description: "Accountdescription", amount: 100) {
        
    }
}
