//
//  SetNickNameView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI
import Combine

struct SetNickNameView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var nickName: String = ""
    @State private var isValidNickName = false
    @State private var isValidatingNickName = false
    @State private var isNavigationLinkActive = false
    @FocusState private var isFocused: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        loginViewModel.signOut()
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                    Spacer()
                }
                Spacer()
                    .frame(maxHeight: 76)
                description()
                setNickName()
                    .padding(.vertical, 40)
                nextButton()
                    .padding(.top, 24)
                Spacer()
            }
            NavigationLink(destination: SetProfileImageView(), isActive: $isNavigationLinkActive) {
                EmptyView()
            }
            .hidden()
        }
    }
    
    @ViewBuilder
    func description() -> some View {
        VStack(spacing: 8) {
            Text("어푸어푸에 오신 걸 환영합니다!")
                .font(.system(size: 22, weight: .bold))
            Text("사용하실 닉네임을 알려주세요.")
                .font(.system(size: 22, weight: .bold))
        }
    }
    
    @ViewBuilder
    func setNickName() -> some View {
        VStack {
            TextField("", text: $nickName,
                      prompt: Text("닉네임을 입력해 주세요")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("neutral_500")))
            .font(.system(size: 16, weight: .semibold))
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("neutral_050"))
            }
            .onReceive(Just(nickName)) { _ in
                // 최대 닉네임 글자 수 까지만 입력 가능
                if nickName.count > Constants.maxNickNameLength {
                    nickName = String(nickName.prefix(Constants.maxNickNameLength))
                }
            }
            .onDebouncedChange(of: $nickName, debounceFor: 1) { nickName in
                // 사용자 입력 1초 후 닉네임 유효성 검증
                Task {
                    isValidatingNickName = true
                    isValidNickName = try await loginViewModel.isValidNickName(nickName)
                    print(isValidNickName)
                    isValidatingNickName = false
                }
            }
            HStack {
                Text("한글, 영어, 숫자 이용하여 8글자 이내, 숫자만은 불가능")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("neutral_600"))
                    .padding(.leading, 32)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func nextButton() -> some View {
        Button {
            /* TODO : 다음 버튼 탭 시 username 등록 */
            // 빈칸은 하지 못하게
            // 중복 거르기?
            self.isNavigationLinkActive = true
            loginViewModel.didSetNickName = true
        } label: {
            if isValidNickName {
                Text("다음")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("title.loginButtons"))
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("primary_500"))
                    }
                    .padding(.horizontal, 16)
            } else {
                Text("다음")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("title.loginButtons"))
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundColor(Color("primary_100"))
                    }
                    .padding(.horizontal, 16)
            }
        }
        .padding(.bottom, 40)
    }
}

struct SetNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNickNameView()
            .environmentObject(LoginViewModel())
    }
}
