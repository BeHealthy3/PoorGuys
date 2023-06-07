//
//  SignUpCompletedView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct SignUpCompletedView: View {

    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        /* 디졸브로 사라짐 구현 예정 */
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 159)
            Image("icon.celebration")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .padding(.bottom, 40)
            VStack(spacing: 8) {
                Text("가입이 완료되었습니다!")
                    .font(.system(size: 22, weight: .bold))
                Text("어푸어푸에서 즐거운 시간 보내세요.")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.horizontal, 24)
            Spacer()
            toMainViewButton()
                .padding(.bottom, 40)
        }
        
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func toMainViewButton() -> some View {
        Button {
            loginViewModel.setCurrentUser { isUser, error in
                if let error = error {
                    print("Error while setting current user: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        loginViewModel.didSetNickName = true
                    }
                }
            }
        } label: {
            Text("메인 페이지로")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
        }
    }
}

struct SignUpCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCompletedView()
    }
}
