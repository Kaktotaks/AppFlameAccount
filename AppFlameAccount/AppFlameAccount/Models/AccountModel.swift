//
//  AccountModel.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import Foundation

struct AccountModel: Identifiable, Equatable {
    let id: UUID = .init()
    let date: Date
    let amount: Int
    let name: String
    let description: String
}
