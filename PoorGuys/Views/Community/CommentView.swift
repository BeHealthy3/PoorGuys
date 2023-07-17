//
//  CommentView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/28.
//

import SwiftUI
import Combine

struct CommentView: View {
    
    @State private var showingSheet = false
    
    @State private var comment: Comment
    
    @Binding private var post: Post?
    @Binding private var comments: [Comment]
    @Binding private var replyingCommentID: String?
    @Binding private var replyingNickname: String?
    @Binding private var isCommentLikeButtonEnabled: Bool
    
    @State private var showAlert = false
    @State private var alertMessage: CommentViewAlertMessage = .threeSeconds
    
    @State private var cancellable: AnyCancellable?
    
//    🚨todo: 정상적인 user로 바꿔주기
    private let user = User(uid: "dfkdkeltkqn", nickName: "ewqfg", authenticationMethod: .apple)
    
    init(post: Binding<Post?>, comments: Binding<[Comment]>, comment: Comment, replyingCommentID: Binding<String?>, replyingNickName: Binding<String?>, isLikeButtonEnabled: Binding<Bool>) {
        self._comment = State(initialValue: comment)
        self._post = post
        self._comments = comments
        self._replyingCommentID = replyingCommentID
        self._replyingNickname = replyingNickName
        self._isCommentLikeButtonEnabled = isLikeButtonEnabled
    }
    
    var body: some View {
        VStack {
            
            if comment.isDeletedComment {
                HStack {
                    Text("삭제된 댓글입니다.")
                        .foregroundColor(.appColor(.neutral600))
                        .font(.system(size: 14))
                    Spacer()
                }
                .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                
            } else {
                LazyVStack(spacing: 4) {
                    HStack(spacing: 8) {
                        AsyncImage(url: URL(string: comment.profileImageURL ?? "")) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                            @unknown default:
                                Color.appColor(.neutral100)
                                    .frame(width: 24, height: 24)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Text(comment.nickName + (post?.userID == comment.userID ? " (작성자)" : ""))
                            .lineLimit(1)
                            .foregroundColor(post?.userID == comment.userID ?
                                .appColor(.primary500) : .appColor(.neutral700))
                            .font(.system(size: 12, weight: .bold))
                        
                        Spacer()
                        Image("verticalEllipsis")
                            .onTapGesture {
                                showingSheet = true
                            }
                            .confirmationDialog("", isPresented: $showingSheet) {
                                if let post = post {
                                    Button {
                                        Task {
                                            do {
                                                
                                                try await FirebasePostManager().removeComment(id: comment.id, postID: post.id, handler: { result in
                                                    switch result {
                                                    case .success(let isDeleted):
                                                        if isDeleted {
                                                            withAnimation {
                                                                comment.isDeletedComment = true
                                                            }
                                                        }
                                                        
                                                    case .failure(let error):
                                                        print(error)    //🚨todo: 에러 보여주기
                                                    }
                                                })
                                            }
                                            catch {
                                                print("업데이트실패")
                                            }
                                        }
                                        
                                    } label: {
                                        Text("삭제하기")
                                    }
                                } else {
                                    Button {
                                        print("신고하기")
                                    } label: {
                                        Text("신고하기")
                                    }
                                }
                            }
                    }
                    
                    HStack {
                        Text($comment.content.wrappedValue)
                            .foregroundColor(.appColor(.neutral900))
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    
                    HStack() {
                        Text(DateFormatter().excludeYear(from: comment.timeStamp))
                        
                        if comment.belongingCommentID == nil {
                            Text("답글 쓰기")
                                .onTapGesture {
                                    NotificationCenter.default.post(name: .replyTapped, object: nil, userInfo: nil)
                                    replyingCommentID = comment.id
                                    replyingNickname = comment.nickName
                                }
                        }
                        
                        Spacer()
                        
                        Button {
                            if isCommentLikeButtonEnabled {
                                if comment.userID == user.uid {
                                    alertMessage = .myComment
                                    showAlert = true
                                } else {
                                    do {
                                        isCommentLikeButtonEnabled = false
                                        
                                        Task {
                                            try await toggleCommentLike()
                                            
                                            cancellable = Timer.publish(every: 3, on: .main, in: .common)
                                                .autoconnect()
                                                .sink { _ in
                                                    // 타이머 완료 후 버튼 활성화
                                                    isCommentLikeButtonEnabled = true
                                                }
                                        }
                                    } catch {
                                        print("로그인 에러 또는 좋아요 에러")
                                    }
                                }
                            } else {
                                alertMessage = .threeSeconds
                                showAlert = true
                            }
                        } label: {
                            HStack(spacing: 4) {
                                if comment.likedUserIDs.contains(user.uid) {
                                    Image("thumbsUpFilled")
                                } else {
                                    Image("thumbsUp")
                                        .renderingMode(.template)
                                        .foregroundColor(.appColor(.neutral500))
                                }
                                
                                Text(String(comment.likedUserIDs.count))
                                    .foregroundColor(.appColor(.neutral500))
                                    .font(.system(size: 11))
                            }
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("알림"), message: Text(alertMessage.rawValue), dismissButton: .default(Text("확인")))
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }
    
    private func toggleCommentLike() async throws {
        guard let post = post else { return }
        
        try FirebasePostManager(user: user).toggleCommentLike(commentID: comment.id, postID: post.id, handler: { result in
            switch result {
            case .success(let isLiked):
                DispatchQueue.main.async {
                    if isLiked {
                        comment.likedUserIDs.append(user.uid)
                    } else {
                        comment.likedUserIDs = comment.likedUserIDs.filter { $0 != user.uid }
                    }
                }
            case .failure:
                print("실패")
            }
        })
    }
    
    private func commentsAfterLike(by user: User) -> [Comment] {
        let commentsAfterLike = comments.map({ comment in
            
            var updatedComment = comment
            
            if comment.id == self.comment.id {
                updatedComment.likedUserIDs.append(user.uid)
            }
            
            return updatedComment
        })
        
        return commentsAfterLike
    }
    
    private func commentsAfterUnlike(by user: User) -> [Comment] {
        let commentsAfterUnlike = comments.map({ comment in
            
            var updatedComment = comment
            
            if comment.id == self.comment.id {
                updatedComment.likedUserIDs = updatedComment.likedUserIDs.filter({ userID in
                    userID != user.uid
                })
            }
            
            return updatedComment
        })
        
        return commentsAfterUnlike
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(post: .constant(Post.dummy()), comments: .constant(Comment.multipleDummies(number: 1)), comment: Comment.dummy(), replyingCommentID: .constant(""), replyingNickName: .constant(""), isLikeButtonEnabled: .constant(true))
    }
}

enum CommentViewAlertMessage: String {
    case threeSeconds = "적선하기는 3초에 한번씩 누를 수 있습니다."
    case myComment = "자신의 글에는 적선할 수 없습니다."
}
