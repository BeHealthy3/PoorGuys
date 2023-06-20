//
//  Shape+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

extension Shape {
    func strokeShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        self.stroke(color, lineWidth: 1)
            .shadow(color: color, radius: radius, x: x, y: y)
    }
}
