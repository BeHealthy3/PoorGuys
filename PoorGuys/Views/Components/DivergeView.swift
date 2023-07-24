//
//  DivergeView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/23.
//

import SwiftUI

struct DivergeView<TrueContent: View, FalseContent: View>: View {
    let `if`: Bool
    let `true`: TrueContent
    let `false`: FalseContent

    var body: some View {
        if `if` {
            return AnyView(`true`)
        } else {
            return AnyView(`false`)
        }
    }
}
