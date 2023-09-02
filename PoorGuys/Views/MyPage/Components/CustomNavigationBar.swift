//
//  CustomNavigationBar.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/09/02.
//

import SwiftUI

struct CustomNavigationBar: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    
    var body: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.left")
                }
                .padding(.leading, 16)
                .padding(.vertical, 12)
                Spacer()
            }
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
        }
    }
}

struct CustomNavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavigationBar(title: "서비스 이용약관")
    }
}
