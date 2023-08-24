//
//  TermsOfServicesView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/24.
//

import SwiftUI

struct TermsOfServicesView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            navigationHeader()
            ScrollView {
                Text(Constants.termsOfService)
                    .font(.system(.body))
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
            Text("서비스 이용약관")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
        }
    }
}

struct TermsOfServicesView_Previews: PreviewProvider {
    static var previews: some View {
        TermsOfServicesView()
    }
}
