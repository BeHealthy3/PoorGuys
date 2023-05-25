//
//  LoginView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI
import FirebaseAuth

/// 유저 로그인 화면
struct LoginView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @State private var isPresentingSetNickNameView = false
    
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
        .onChange(of: loginViewModel.signInState) { signInState in
            if signInState == .signedIn {
                self.isPresentingSetNickNameView = true
            }
        }
        .onAppear {
            self.isPresentingSetNickNameView = false
            if loginViewModel.signInState == .signedIn {
                self.isPresentingSetNickNameView = true
            }
        }
        .fullScreenCover(isPresented: $isPresentingSetNickNameView, content: {
            SetNickNameView()
        })
    }
    
    @ViewBuilder
    func googleLoginButton() -> some View {
        Button {
            loginViewModel.signInWithGoogle()
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
            self.isPresentingSetNickNameView = true // 테스트 목적
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
            .environmentObject(LoginViewModel())
    }
}
