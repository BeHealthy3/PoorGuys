//
//  TermsOfServicesView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/24.
//

import SwiftUI

struct TermsOfServicesView: View {
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "서비스 이용약관")
            ScrollView {
                Text(Constants.termsOfService)
                    .font(.system(size: 14))
                    .padding(.horizontal, 16)
            }
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
}

struct TermsOfServicesView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServicesView()
    }
}
