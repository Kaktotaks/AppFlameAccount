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
    let amount: Int
    let onTapGesture: () -> Void
    
    var body: some View {
        Button {
            onTapGesture()
        } label: {
            VStack(alignment: .leading) {
                HStack {
                    Image(.bankLogo)
                        .frame(width: 48, height: 48)
                        .padding(.horizontal, 16)
                    
                    VStack(alignment: .leading) {
                        Text(name)
                            .font(.subheadline)
                        Text(description)
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Text("$\(amount)")
                        .font(.subheadline)
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
