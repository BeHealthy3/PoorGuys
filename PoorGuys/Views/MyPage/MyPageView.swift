//
//  MyPageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    var body: some View {
        VStack {
            profileCard()
        }
    }
    
    @ViewBuilder
    func profileCard() -> some View {
        VStack(spacing: 4) {
            HStack {
                Spacer()
                Button {
                    /* TODO : EditProfileView로 네비게이션 */
                } label: {
                    Image("icon.edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 24)
            }
            .padding(.top ,8)
            HStack(spacing: 20) {
                Image(uiImage: (User.currentUser?.profileImage)!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(User.currentUser!.nickName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("primary_500"))
                    switch User.currentUser!.authenticationMethod {
                    case .google:
                        Text("구글 연동")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("neutral_900"))
                    case .apple:
                        Text("애플 연동")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(Color("neutral_900"))
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            HStack {
                Spacer()
                Button {
                    loginViewModel.signOut()
                } label: {
                    Text("로그아웃")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(Color("neutral_700"))
                }
                .padding(.trailing, 24)
                .padding(.vertical, 4)
            }
            .padding(.bottom, 8)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(Color("white"))
                .shadow(color: Color(uiColor: UIColor(red: 0, green: 0.511, blue: 1, alpha: 0.2)), radius: 7)
        }
        .padding(.horizontal, 16)
    }
    
}

struct MyPageView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyPageView()
            .environmentObject(LoginViewModel())
    }
}
