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

struct AccountViewSkeletonCell: View {
    var body: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 48, height: 48)
                .padding(.horizontal, 16)
                .shimmering()

            VStack(alignment: .leading, spacing: 6) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 14)
                    .shimmering()

                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 150, height: 12)
                    .shimmering()
            }

            Spacer()

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 60, height: 14)
                .padding(.trailing, 16)
                .shimmering()
        }
        .frame(height: 64)
    }
}

