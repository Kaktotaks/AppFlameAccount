//
//  CSVLoader.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 25.05.2025.
//

import Foundation

enum LoaderFileNames: String {
    case accounts = "accounts"
}

struct CSVLoader {
    static func loadAccountData(from fileName: LoaderFileNames) -> [AccountModel] {
        guard let url = Bundle.main.url(forResource: fileName.rawValue, withExtension: "csv"),
              let content = try? String(contentsOf: url) else {
            debugPrint("❌ CSV not found")
            return []
        }
        
        let lines = content.components(separatedBy: .newlines).filter { !$0.isEmpty }
        let rows = lines.dropFirst()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return rows.compactMap { row in
            let columns = row.components(separatedBy: ",")
            guard columns.count >= 5,
                  let date = formatter.date(from: columns[1]),
                  let amount = Double(columns[4]) else {
                return nil
            }
            
            return AccountModel(
                date: date,
                amount: amount, name: columns[2],
                description: columns[3]
            )
        }
    }
}
