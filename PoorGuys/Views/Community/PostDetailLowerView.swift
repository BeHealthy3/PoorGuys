//
//  PostDetailLowerView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailLowerView: View {
    
    var post: Post
    
    @Binding private var comments: [Comment]
    @Binding private var replyingCommentID: String?
    @Binding private var replyingNickname: String?
    @Binding private var newlyAddedComment: Comment?
    
    @State private var text: String = ""
    @State private var viewHeight: CGFloat = 60
    @State private var backgroundNeedsHighlight = false
    
    init(post: Post, comments: Binding<[Comment]>, replyingCommentID: Binding<String?>, replyingNickname: Binding<String?>, newlyAddedComment: Binding<Comment?>) {
        self.post = post
        self._comments = comments
        self._replyingCommentID = replyingCommentID
        self._replyingNickname = replyingNickname
        self._newlyAddedComment = newlyAddedComment
    }
    
    var body: some View {
        VStack {
            if replyingCommentID != nil {
                EmptyView()
                    .frame(height: 8, alignment: .top)
            }
            
            HStack(spacing: 8) {
                VStack {
                    Spacer(minLength: 0)
                        .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                    AsyncImage(url: URL(string: post.profileImageURL ?? "")) { image in
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                    } placeholder: {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                }

                HStack(spacing: 8) {

                    TextEditorView(text: $text, textEditorHeight: $viewHeight, backgroundNeedsHighlight: $backgroundNeedsHighlight)

                    VStack {
                        Spacer(minLength: 0)
                            .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                        Button {
                            
                            do {
                                let user = User(uid: "dfkdkeltkqn", nickName: "hihi", profileImageURL: "https://picsum.photos/200/300", authenticationMethod: .apple)
//                                guard let user = User.currentUser else { throw FirebaseError.userNotFound }
                                
                                let newComment = Comment(id: UUID().uuidString, nickName: user.nickName, profileImageURL: user.profileImageURL, userID: user.uid, postID: post.id, content: text, likedUserIDs: [], timeStamp: Date(), isDeletedComment: false, belongingCommentID: replyingCommentID)
                                
                                Task {
                                    do {
                                        try FirebasePostManager().addNewComment(with: newComment, postID: post.id) { result in
                                            switch result {
                                            case .success:
                                                withAnimation {
                                                    text = ""
                                                    replyingCommentID = nil
                                                    replyingNickname = nil
                                                    comments.append(newComment)
                                                    newlyAddedComment = newComment
                                                }
                                            case .failure(let error):
                                                print(error)    //🚨todo: 에러표시
                                            }
                                        }
                                    }
                                    catch {
                                        print("업데이트실패")
                                    }
                                }
                            } catch {
                                print("인증 정보 오류")
                            }
                        } label: {
                            Image("sendButton")
                                .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 16))
                        }
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            backgroundNeedsHighlight ? .appColor(.primary500) : Color.appColor(.neutral900).opacity(0.1),
                            lineWidth: backgroundNeedsHighlight ? 1 : 1
                        )
                        .shadow(
                            color: backgroundNeedsHighlight ? Color.clear : Color.black.opacity(0.1),
                            radius: 7,
                            x: 0,
                            y: 0
                        )
                )
            }
        }
    }
    
//    func updatedComments(with newComment: Comment) -> [Comment] {
//            if let belongingCommentID = newComment.belongingCommentID,
//               var comments = comments {
//                
//                if let lastIndex = comments.lastIndex(where: { $0.belongingCommentID == belongingCommentID }) {
//                    comments.insert(newComment, at: lastIndex + 1)
//                } else {
//                    if let index = comments.firstIndex(where: { $0.id == belongingCommentID }) {
//                        comments.insert(newComment, at: index + 1)
//                    }
//                }
//                
//                return comments
//                
//            } else {
//                return [newComment]
//            }
//    }
}

struct PostDetailLowerView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailLowerView(post: Post.dummy(), comments: .constant([]), replyingCommentID: .constant(String.randomString(length: 10)), replyingNickname: .constant(nil), newlyAddedComment: .constant(nil))
    }
}
