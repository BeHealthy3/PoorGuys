//
//  AppColor.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/25.
//

import SwiftUI

enum AssetColor: String {
    case primary050, primary100, primary200, primary300, primary400, primary500, primary600, primary700, primary800, primary900
    case neutral050, neutral100, neutral200, neutral300, neutral400, neutral500, neutral600, neutral700, neutral800, neutral900
    case secondary, white, red, lightRed
}

extension Color {
    
    static func appColor(_ name: AssetColor) -> Color {
        switch name {
        case .primary050:
            return Color("primary050")
        case .primary100:
            return Color("primary100")
        case .primary200:
            return Color("primary200")
        case .primary300:
            return Color("primary300")
        case .primary400:
            return Color("primary400")
        case .primary500:
            return Color("primary500")
        case .primary600:
            return Color("primary600")
        case .primary700:
            return Color("primary700")
        case .primary800:
            return Color("primary800")
        case .primary900:
            return Color("primary900")
        case .neutral050:
            return Color("neutral050")
        case .neutral100:
            return Color("neutral100")
        case .neutral200:
            return Color("neutral200")
        case .neutral300:
            return Color("neutral300")
        case .neutral400:
            return Color("neutral400")
        case .neutral500:
            return Color("neutral500")
        case .neutral600:
            return Color("neutral600")
        case .neutral700:
            return Color("neutral700")
        case .neutral800:
            return Color("neutral800")
        case .neutral900:
            return Color("neutral900")
        case .secondary:
            return Color("secondary")
        case .white:
            return Color("white")
        case .red:
            return Color("red")
        case .lightRed:
            return Color("lightRed")
        }
    }
}
