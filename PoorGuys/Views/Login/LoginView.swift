//
//  LoginView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            Spacer()
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(.gray)
                .padding(.horizontal, 16)
                .aspectRatio(1, contentMode: .fit)
            Spacer()
            VStack(spacing: 10) {
                googleLoginButton()
                appleLoginButton()
            }
            .padding(.bottom, 40)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func googleLoginButton() -> some View {
        Button {
           /* TODO : google authentication */
        } label: {
            Text("구글로 로그인하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .background(.gray)
        .cornerRadius(12)
    }
    
    @ViewBuilder
    func appleLoginButton() -> some View {
        Button {
           /* TODO : apple authentication*/
        } label: {
            Text("애플로 로그인하기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
                .padding(.vertical, 16)
        }
        .frame(maxWidth: .infinity)
        .background(.gray)
        .cornerRadius(12)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
