//
//  PostDetailUpperView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailUpperView: View {
    
    @State var post: Post
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var isModalPresented: Bool
    @Binding var nowLookingPostID: ID
    @Binding var upperViewNeedsRefresh: Bool
    @Binding var communityViewNeedsRefresh: Bool
    
    @State private var isLiked = false
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var alertMessage: PostDetailUpperViewAlertMessage = .alreadyReportedPost
    
    //    🚨todo: user 없애기
    let user = User.currentUser!
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: post.profileImageURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .clipShape(Circle())
                    @unknown default:
                        Color.appColor(.neutral100)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                }
                
                Text(post.nickName)
                    .lineLimit(1)
                    .foregroundColor(.appColor(.neutral700))
                    .font(.system(size: 12, weight: .bold))
                
                Spacer()
                
                Image("verticalEllipsis")
                    .onlyIf(user.uid == post.userID)
                    .onTapGesture {
                        showingSheet = true
                    }
                    .confirmationDialog("", isPresented: $showingSheet) {
                        Button(role: .destructive) {
                            removePost()
                        } label: {
                            Text("삭제하기")
                        }
                        Button {
                            isModalPresented = true
                        } label: {
                            Text("수정하기")
                        }
                    }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    Image("stamp")
                        .onlyIf(post.isAboutMoney)
                        .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                    
                    Text(post.title)
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.appColor(.neutral900))
                    
                }
                Text(post.body)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 16))
                    .foregroundColor(.appColor(.neutral900))
            }
            
            AsyncImage(url: URL(string: post.imageURL.first ?? "")) { image in
                image.resizable()
                    .frame(width: 311, height: 311)
            } placeholder: {
                Color.appColor(.neutral100)
                    .frame(width: 311, height: 311)
            }
            .onlyIf(!post.imageURL.isEmpty)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(DateFormatter().excludeYear(from: post.timeStamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.appColor(.neutral100))
                
                bottomThreeButtons()
            }
            .onAppear {
                isLiked = post.likedUserIDs.contains(user.uid)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .onChange(of: upperViewNeedsRefresh) { needsRefresh in
            Task {
                if needsRefresh {
                    do {
                        post = try await FirebasePostManager().fetchPost(postID: post.id)
                        upperViewNeedsRefresh = false
                    } catch {
                        print("실패") //🚨todo: 에러처리
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func bottomThreeButtons() -> some View {
        HStack {
            Button {
                if post.userID != user.uid {
                    toggleLike()
                } else {
                    showCantLikeAlert()
                }
                
            } label: {
                HStack {
                    DivergeView(if: isLiked, true: Image("likeHighlighted"), false: Image("like"))
                        .frame(width: 16, height: 16)
                    
                    Text("적선하기")
                        .font(.system(size: 11))
                        .lineLimit(1)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage.rawValue), dismissButton: .default(Text("확인")))
            }
            
            Spacer()
            
            Button {
                NotificationCenter.default.post(name: .replyTapped, object: nil, userInfo: nil)
            } label: {
                HStack {
                    Image("comment")
                        .frame(width: 16, height: 16)
                    Text("댓글쓰기")
                        .font(.system(size: 11))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Button {
                reportPost()
            } label: {
                HStack {
                    Image("siren")
                        .frame(width: 16, height: 16)
                    Text("신고하기")
                        .font(.system(size: 11))
                        .lineLimit(1)
                }
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage.rawValue), dismissButton: .default(Text("확인")))
            }
        }
        .foregroundColor(.appColor(.neutral600))
    }
    
    private func removePost() {
        Task.detached {
            do {
                try await FirebasePostManager().removePost(postID: post.id)
                try await FirebasePostManager().removePostFromUserPosts(postID: post.id)
            } catch {
                print("삭제 실패")  //todo: 얼럿 띄우기
            }
            
            DispatchQueue.main.async {
                communityViewNeedsRefresh = true
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
    
    private func toggleLike() {
        Task {
            do {
                try FirebasePostManager(user: user).toggleLike(about: post.id, handler: { result in
                    switch result {
                    case .success(let isSuccess):
                        DispatchQueue.main.async {
                            if isSuccess {
                                isLiked.toggle()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                })
                
            } catch {
                print("좋아요 혹은 좋아요 취소 실패")
            }
        }
    }
    
    private func showCantLikeAlert() {
        alertMessage = .cantLikeMyPost
        showingAlert = true
    }
    
    private func reportPost() {
        Task {
            FirebasePostManager(user: user).reportPost(id: post.id, userID: post.userID, nickName: post.nickName, title: post.title, body: post.body) { result in
                switch result {
                case .success:
                    alertMessage = .reportSucceeded
                    showingAlert = true
                case .failure(let error):
                    if error == .alreadyReported {
                        alertMessage = .alreadyReportedPost
                        showingAlert = true
                    }
                }
            }
        }
    }
}

enum PostDetailUpperViewAlertMessage: String {
    case cantLikeMyPost = "자신의 글에는 적선할 수 없습니다."
    case alreadyReportedPost = "이미 신고한 게시글/유저 입니다."
    case reportSucceeded = "신고가 완료되었습니다."
}
