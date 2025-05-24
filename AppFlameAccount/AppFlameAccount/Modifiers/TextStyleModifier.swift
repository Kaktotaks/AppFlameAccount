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
        case .accountListDescriptionTitle:
            return .system(size: 13, weight: .light)
        case .accountNameTitle:
            return .system(size: 16, weight: .regular)
        case .accountDescriptionTitle:
            return .system(size: 13, weight: .light)
        case .accountListAmmount, .accountsListTitle:
            return .system(size: 16, weight: .regular)
        case .detailsAccountNameTitle:
            return .system(size: 24, weight: .regular)
        case .detailsAccountDescriptionTitle:
            return .system(size: 16, weight: .light)
        case .detailsAccountAmmount:
            return .system(size: 40, weight: .regular)
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
    
    var color: Color {
        switch self {
        case .dateDescription, .accountDescriptionTitle, .detailsAccountDescriptionTitle:
            return Color.gray
        case .secondaryBalance:
            return .whiteSecondary
        default:
            return .primaryText
        }
    }
}

struct CustomTextStyle: ViewModifier {
    var font: Font = .subheadline
    var alignment: TextAlignment = .center
    var color: Color = .primary
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .multilineTextAlignment(alignment)
            .foregroundColor(color)
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(CustomTextStyle(font: style.font, alignment: style.alignment))
    }
}
