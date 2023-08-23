
//
//  CustomBottomSheet.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/27.
//

import SwiftUI

protocol ViewModelable {}

struct CustomBottomSheet<Content: View>: View {
    var content: Content
    var withNotchHeight: CGFloat
    var withoutNotchheight: CGFloat

    var body: some View {
        VStack(spacing: 0) {
            content
                .if(UIDevice.current.hasNotch, transform: { view in
                    view.frame(height: withNotchHeight)
                })
                .if(!UIDevice.current.hasNotch, transform: { view in
                    view.frame(height: withoutNotchheight)
                })
                .cornerRadius(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .zIndex(10)
    }
}
