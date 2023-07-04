//
//  CommentView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/28.
//

import SwiftUI

struct CommentView: View {
    
    @State private var showingSheet = false
    
    @State private var comment: Comment = Comment.dummy()
    
    @Binding private var post: Post?
    @Binding private var comments: [Comment]?
    @Binding private var replyingCommentID: String?
    @Binding private var replyingNickname: String?
    
    init(post: Binding<Post?>, comments: Binding<[Comment]?>, comment: Comment, replyingCommentID: Binding<String?>, replyingNickName: Binding<String?>) {
        self._comment = State(initialValue: comment)
        self._post = post
        self._comments = comments
        self._replyingCommentID = replyingCommentID
        self._replyingNickname = replyingNickName
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
                        AsyncImage(url: URL(string: comment.profileImageURL ?? "")) { image in
                            image.resizable()
                                .frame(width: 24, height: 24)
                                .clipShape(Circle())
                            
                        } placeholder: {
                            ProgressView()
                                .frame(width: 24, height: 24)
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
                                if let user = User.currentUser, comment.userID == user.uid {
                                    //                                if comment.userID == "dummyUserIDUtVjUYszAN" {
                                    Button {
                                        Task {
                                            do {
                                                let updatedComments = removedComments()
                                                guard var updatedPost = self.post else { return }   //🚨todo: 에러던지기
                                                
                                                updatedPost.comments = updatedComments
                                                
                                                try await FirebasePostManager().updateCommentsAndCommentsCount(with: updatedPost)
                                                
                                                withAnimation {
                                                    self.comments = updatedComments
                                                }
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
                        Text(comment.content)
                            .foregroundColor(.appColor(.neutral900))
                            .multilineTextAlignment(.leading)
                            .font(.system(size: 14))
                        Spacer()
                    }
                    
                    HStack() {
                        Text(DateFormatter().excludeYear(from: comment.timeStamp))
                        Spacer()
                        HStack(spacing: 8) {
                            
                            HStack(spacing: 10) {
                                if comment.belongingCommentID == nil {
                                    Text("답글 쓰기")
                                        .onTapGesture {
                                            NotificationCenter.default.post(name: .replyTapped, object: nil, userInfo: nil)
                                            replyingCommentID = comment.id
                                            replyingNickname = comment.nickName
                                        }
                                }
                                
                                Button {
                                    do {
                                        guard let user = User.currentUser else { throw LoginError.noCurrentUser }
//                                        let user = User(uid: "Asdfas", nickName: "ewqfg", authenticationMethod: .apple)
                                        guard var updatedPost = post else { return }
                                        let updatedComments = commentsAfterLike(by: user)
                                        
                                        updatedPost.comments = updatedComments
                                        
                                        Task {
                                            try await FirebasePostManager(user: user).updateComments(with: updatedPost)
                                        }
                                        
                                        comment.likeCount += 1
                                        
                                    } catch {
                                        print("로그인 에러 또는 좋아요 에러")
                                    }
                                    
                                } label: {
                                    HStack(spacing: 4) {
                                        Image("thumbsUp")
                                            .renderingMode(.template)
                                            .foregroundColor(.appColor(.neutral500))
                                        Text(String(comment.likeCount))
                                            .foregroundColor(.appColor(.neutral500))
                                            .font(.system(size: 11))
                                    }
                                }
                            }
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
        }
    }
    
    private func removedComments() -> [Comment]? {
        
        let commentRemovedComments = comments?.map({ comment in
            var updatedComment = comment
            if updatedComment.id == comment.id {
                updatedComment.isDeletedComment = true
            }
            
            return updatedComment
        })
        return commentRemovedComments
    }
    
    private func commentsAfterLike(by user: User) -> [Comment]? {
        let commentsAfterLike = comments?.map({ comment in
            
            var updatedComment = comment
            
            if comment.id == comment.id {
                updatedComment.likeCount += 1
                updatedComment.likedUserIDs.append(user.uid)
            }
            
            return updatedComment
        })
        
        return commentsAfterLike
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        CommentView(post: .constant(Post.dummy()), comments: .constant(Comment.multipleDummies(number: 1)), comment: Comment.dummy(), replyingCommentID: .constant(""), replyingNickName: .constant(""))
    }
}
