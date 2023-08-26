//
//  MyPageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import SwiftUI

struct MyPageView: ContentView {
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isTabBarHidden: Bool
    @State private var currentUser: User = User(uid: "", nickName: "", authenticationMethod: .google)
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                navigationHeader()
                ScrollView {
                    VStack(spacing: 0) {
                        profileCard()
                            .padding(.top, 8)
                        myRelatedPosts()
                            .padding(.top, 24)
                        additionalInfos()
                            .padding(.top, 16)
                        Spacer()
                    }
                }
            }
            .onAppear {
                if let user = User.currentUser {
                    self.currentUser = user
                }
                
                withAnimation(.easeInOut) {
                    isTabBarHidden = false
                }
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
            NavigationLink(destination: UserPostsView(isTabBarHidden: $isTabBarHidden)) {
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
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            NavigationLink(destination: LikedPostsView(isTabBarHidden: $isTabBarHidden)) {
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
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            NavigationLink(destination: CommentedPostsView(isTabBarHidden: $isTabBarHidden)) {
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
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 24)
            Divider()
        } // end of VStack
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func additionalInfos() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("서비스 이용 약관")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_800"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            HStack {
                Text("개인정보 처리방침")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_800"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            HStack {
                Text("문의하기")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_800"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            HStack {
                Text("공지사항")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_800"))
                Spacer()
                Image("arrow.right.gray")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            HStack {
                Text("앱 버전")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_800"))
                Spacer()
                Text("현재 버전 \((Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!)")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("neutral_500"))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 16)
            Divider()
        } // end of VStack
        .padding(.horizontal, 16)
    }
}
