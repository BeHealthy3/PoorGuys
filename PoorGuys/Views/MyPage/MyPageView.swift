//
//  MyPageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var currentUser: User = User(uid: "", nickName: "", authenticationMethod: .google)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                navigationHeader()
                ScrollView {
                    profileCard()
                        .padding(.top, 8)
                    myRelatedPosts()
                        .padding(.top, 24)
                    Spacer()
                }
            }
        }
        .onAppear {
            if let user = User.currentUser {
                self.currentUser = user
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
            Text("마이페이지")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
        }
    }
    
    @ViewBuilder
    func profileCard() -> some View {
        VStack(spacing: 4) {
            HStack {
                Spacer()
                NavigationLink(destination: EditProfileView(currentUser: $currentUser)) {
                    Image("icon.edit")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, 24)
            }
            .padding(.top ,8)
            HStack(spacing: 20) {
                Image(uiImage: (currentUser.profileImage) ?? UIImage(named: "user.default")!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 68, height: 68)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text(currentUser.nickName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(Color("primary_500"))
                    switch currentUser.authenticationMethod {
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
    
    @ViewBuilder
    func myRelatedPosts() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image("icon.document")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("내가 쓴 게시글")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            HStack(spacing: 8) {
                Image("icon.like")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("적선한 게시글")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            HStack(spacing: 8) {
                Image("icon.message")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("댓글 쓴 게시글")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            Divider()
        } // end of VStack
        .padding(.horizontal, 24)
    }
    
    
}

struct MyPageView_Previews: PreviewProvider {
    
    static var previews: some View {
        MyPageView()
            .environmentObject(LoginViewModel())
    }
}
