//
//  PrivacyPolicyView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/22.
//

import SwiftUI

struct PrivacyPolicyView: View {

    var body: some View {
        VStack {
            CustomNavigationBar(title: "개인정보 처리방침")
            ScrollView {
                Text(Constants.privacyPolicy)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
            }
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView()
    }
}
