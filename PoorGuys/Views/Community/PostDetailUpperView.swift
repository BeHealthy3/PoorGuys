//
//  PostDetailUpperView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailUpperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var post: Post
    @State var isLiked = false
    
    @State private var showingSheet = false
    @State private var showingAlert = false
    @State private var isModalPresented = false
    @State private var alertMessage: PostDetailUpperViewAlertMessage = .alreadyReportedPost
    
//    🚨todo: 없애기
    let user = User(uid: "nklasdkfqwe", nickName: "mollu", authenticationMethod: .apple)
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: post.profileImageURL ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .frame(width: 40, height: 40)
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
                    .onTapGesture {
                        showingSheet = true
                    }
                    .confirmationDialog("", isPresented: $showingSheet) {
                        if user.uid == post.userID {
                            Button(role: .destructive) {
                                
                                Task.detached {
                                    do {
                                        try await FirebasePostManager().removePost(postID: post.id)
                                    } catch {
                                        print("삭제 실패")
                                    }
                                    
                                    DispatchQueue.main.async {
                                        presentationMode.wrappedValue.dismiss()
                                    }
                                }
                                
                            } label: {
                                Text("삭제하기")
                            }
                            Button {
                                isModalPresented = true
                            } label: {
                                Text("수정하기")
                            }
                            .fullScreenCover(isPresented: $isModalPresented) {
                                PostFillingView(isPresented: $isModalPresented, needsRefresh: .constant(false), postID: .constant(post.id))
                            }
                            
                        } else {
                            Button {
                                Task {
                                    FirebasePostManager(user: user).reportPost(id: post.id,userID: post.userID,nickName: post.nickName, title: post.title, body: post.body) { result in
                                        switch result {
                                        case .success:
                                            print("성공")
                                        case .failure(let error):
                                            print(error)    //🚨todo: 얼럿띄우기
                                        }
                                    }
                                }
                            } label: {
                                Text("닉네임 신고하기")
                            }
                        }
                    }
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 8) {
                    if post.isAboutMoney {
                        Image("stamp")
                            .padding(EdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0))
                    }
                    
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
            
            if !post.imageURL.isEmpty {
                AsyncImage(url: URL(string: post.imageURL.first ?? "")) { image in
                    image.resizable()
                        .frame(width: 311, height: 311)
                } placeholder: {
                    Color.appColor(.neutral100)
                        .frame(width: 311, height: 311)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(DateFormatter().excludeYear(from: post.timeStamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.appColor(.neutral100))
                
                HStack {
                    Button {
                        if post.userID != user.uid {
                            Task {
                                do {
                                    try FirebasePostManager(user: user).toggleLike(about: post.id, handler: { result in
                                        switch result {
                                        case .success(let isSuccess):
                                            DispatchQueue.main.async {
                                                if isSuccess {
                                                    print("🚨")
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
                        } else {
                            alertMessage = .cantLikeMyPost
                            showingAlert = true
                        }
                        
                    } label: {
                        HStack {
                            if isLiked {
                                Image("likeHighlighted")
                                    .frame(width: 16, height: 16)
                            } else {
                                Image("like")
                                    .frame(width: 16, height: 16)
                            }
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
                        Task {
                            FirebasePostManager(user: user).reportPost(id: post.id,userID: post.userID,nickName: post.nickName, title: post.title, body: post.body) { result in
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
            .onAppear {
                isLiked = post.likedUserIDs.contains(user.uid)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}

struct PostDetailUpperView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailUpperView(post: Post.dummy())
    }
}

enum PostDetailUpperViewAlertMessage: String {
    case cantLikeMyPost = "자신의 글에는 적선할 수 없습니다."
    case alreadyReportedPost = "이미 신고한 게시글/유저 입니다."
    case reportSucceeded = "신고가 완료되었습니다."
}
