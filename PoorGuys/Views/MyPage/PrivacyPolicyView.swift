//
//  PrivacyPolicyView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/22.
//

import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            navigationHeader()
            ScrollView {
                Text(Constants.privacyPolicy)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
            }
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func navigationHeader() -> some View {
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
            Text("개인정보 처리방침")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
