//
//  SetNickNameView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct SetNickNameView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var nickName: String = ""
    @State private var isNavigationLinkActive = false
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                        .frame(height: 200)
                    Text("거지방에 오신 걸 환영합니다!")
                        .font(.system(size: 22, weight: .bold))
                    Text("사용하실 닉네임을 알려주세요.")
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                    Button {
                        /* TODO : 다음 버튼 탭 시 username 등록 */
                        // 빈칸은 하지 못하게
                        // 중복 거르기?
                        self.isNavigationLinkActive = true
                    } label: {
                        Text("다음")
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
                    .padding(.bottom, 40)
                }
                setNickName()
                    .padding(.horizontal, 16)
                NavigationLink(destination: SetProfileImageView(), isActive: $isNavigationLinkActive) {
                    EmptyView()
                }
                .hidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            loginViewModel.signOut()
                            dismiss()
                        } label: {
                            Image(systemName: "xmark")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func setNickName() -> some View {
        TextField("닉네임", text: $nickName)
            .font(.system(size: 16, weight: .semibold))
            .padding(.vertical)
            .padding(.horizontal)
            .background{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.gray)
            }
    }
}

struct SetNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNickNameView()
            .environmentObject(LoginViewModel())
    }
}
