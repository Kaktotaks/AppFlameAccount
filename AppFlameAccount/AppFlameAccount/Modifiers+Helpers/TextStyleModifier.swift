//
//  TextStyleModifier.swift
//  AppFlameAccount
//
//  Created by Леонід Шевченко on 23.05.2025.
//

import SwiftUI

enum TextStyle {
    case mainBalance
    case mainBalanceDeclima
    case dateDescription
    case accountsListTitle
    case accountListDescriptionTitle
    case accountDescriptionTitle
    case accountListAmmount
    case detailsAccountNameTitle
    case detailsAccountDescriptionTitle
    case detailsAccountAmmount
    case detailsAccountAmmountDeclima
    
    var font: Font {
        switch self {
        case .mainBalance:
            return .system(size: 48, weight: .semibold)
        case .mainBalanceDeclima:
            return .system(size: 26, weight: .semibold)
        case .dateDescription:
            return .system(size: 13, weight: .regular)
        case .accountListDescriptionTitle:
            return .system(size: 13, weight: .light)
        case .accountDescriptionTitle:
            return .system(size: 13, weight: .light)
        case .accountListAmmount, .accountsListTitle:
            return .system(size: 16, weight: .semibold)
        case .detailsAccountNameTitle:
            return .system(size: 24, weight: .regular)
        case .detailsAccountDescriptionTitle:
            return .system(size: 16, weight: .light)
        case .detailsAccountAmmount:
            return .system(size: 40, weight: .regular)
        case .detailsAccountAmmountDeclima:
            return .system(size: 24, weight: .regular)
        }
    }
    
    var alignment: TextAlignment {
        switch self {
        case .accountsListTitle, .accountListDescriptionTitle:
                .leading
        case .accountListAmmount:
                .trailing
        default:
                .center
        }
    }
    
    var color: Color {
        switch self {
        case .mainBalance, .dateDescription, .mainBalanceDeclima:
            return .white
        case .accountDescriptionTitle, .detailsAccountDescriptionTitle:
            return Color.gray
        default:
            return .primaryText
        }
    }
}

struct CustomTextStyle: ViewModifier {
    var font: Font = .subheadline
    var alignment: TextAlignment = .center
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .font(font)
            .multilineTextAlignment(alignment)
            .foregroundColor(color)
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(CustomTextStyle(font: style.font, alignment: style.alignment, color: style.color))
    }
}
