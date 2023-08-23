//
//  RoundButton.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/10.
//

import SwiftUI

struct RoundButton: View {
    var imageName: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.appColor(.white))
                .shadow(color: .black.opacity(0.1), radius: 7.5, x: 0, y: 0)
                .frame(width: 56, height: 56)
            Image(imageName)
                .frame(width: 34, height: 34)
        }
    }
}
