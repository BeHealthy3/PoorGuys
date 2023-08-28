//
//  ContentView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/26.
//

import SwiftUI

protocol TabBarHiderView: View {
    var isTabBarHidden: Bool { get set }
}

struct TabBarHiderViewBottomModifier: ViewModifier {
    func body(content: Content) -> some View {
        if UIDevice().hasNotch {
            content.padding(.bottom, 104)
        } else {
            content.padding(.bottom, 84)
        }
    }
}

extension View {
    func giveBottomPaddingForTabBar() -> some View {
        self.modifier(TabBarHiderViewBottomModifier())
    }
}
