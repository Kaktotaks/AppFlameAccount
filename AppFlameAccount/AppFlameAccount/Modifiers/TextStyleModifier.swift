//
//  TextStyleModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI

enum TextStyle {
    case mainTitle
    case mainBalance
    case secondaryBalance
    case dateDescription
    case periodTitle
    case accountsListTitle
    case accountListDescriptionTitle
    case accountNameTitle
    case accountDescriptionTitle
    case accountListAmmount
    case detailsAccountNameTitle
    case detailsAccountDescriptionTitle
    case detailsAccountAmmount
    
    var font: Font {
        switch self {
        case .mainTitle:
            return .system(size: 34, weight: .bold)
        case .mainBalance:
            return .system(size: 28, weight: .semibold)
        case .secondaryBalance:
            return .system(size: 24, weight: .regular)
        case .dateDescription:
            return .system(size: 14, weight: .regular)
        case .periodTitle:
            return .system(size: 16, weight: .medium)
        case .accountsListTitle:
            return .system(size: 20, weight: .semibold)
        case .accountListDescriptionTitle:
            return .system(size: 16, weight: .regular)
        case .accountNameTitle:
            return .system(size: 18, weight: .medium)
        case .accountDescriptionTitle:
            return .system(size: 14, weight: .regular)
        case .accountListAmmount:
            return .system(size: 16, weight: .bold)
        case .detailsAccountNameTitle:
            return .system(size: 22, weight: .semibold)
        case .detailsAccountDescriptionTitle:
            return .system(size: 16, weight: .regular)
        case .detailsAccountAmmount:
            return .system(size: 20, weight: .bold)
        }
    }
    
    var alignment: TextAlignment {
        switch self {
        case .accountsListTitle, .accountListDescriptionTitle , .accountNameTitle:
                .leading
        case .accountListAmmount:
                .trailing
        default:
                .center
        }
    }
}

struct CustomTextStyle: ViewModifier {
    var font: Font = .subheadline
    var alignment: TextAlignment = .center
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .multilineTextAlignment(alignment)
    }
}

extension View {
    func customTextStyle(textStyle: TextStyle) -> some View {
        self.modifier(CustomTextStyle(font: textStyle.font, alignment: textStyle.alignment))
    }
}
