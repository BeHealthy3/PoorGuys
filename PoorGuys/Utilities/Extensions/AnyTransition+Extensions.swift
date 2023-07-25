//
//  AnyTransition+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/25.
//

import SwiftUI

extension AnyTransition {
    static var bottomToTop: AnyTransition {
        let insertion = AnyTransition.move(edge: .bottom)
        let removal = AnyTransition.move(edge: .bottom)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
