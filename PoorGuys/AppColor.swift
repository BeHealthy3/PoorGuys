//
//  AppColor.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/25.
//

import SwiftUI

enum AssetColor: String {
    case primary, secondary
}

extension Color {
    
    static func appColor(_ name: AssetColor) -> Color {
        switch name {
        case .primary:
            return Color("primary")
        case .secondary:
            return Color("secondary")
        }
    }
}
