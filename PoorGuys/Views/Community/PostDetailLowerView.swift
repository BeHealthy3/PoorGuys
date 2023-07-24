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
            EmptyView()
                .onlyIf(replyingCommentID != nil)
                .frame(height: 8, alignment: .top)
            
            HStack(spacing: 8) {
                VStack {
                    Spacer(minLength: 0)
                        .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                    AsyncImage(url: URL(string: post.profileImageURL ?? "")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        @unknown default:
                            Color.appColor(.neutral100)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                    }
                }

                HStack(spacing: 8) {

                    TextEditorView(text: $text, textEditorHeight: $viewHeight, backgroundNeedsHighlight: $backgroundNeedsHighlight)

                    VStack {
                        Spacer(minLength: 0)
                            .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                        
                        Button {
                            addNewComment()
                            
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
    
    private func addNewComment() {
        do {
            let user = User.currentUser!    //🚨todo: user바꾸기
            
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
                    print("업데이트실패") //🚨todo: 에러표시
                }
            }
        } catch {
            print("인증 정보 오류")   //🚨todo: 에러표시
        }
    }
}

struct PostDetailLowerView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailLowerView(post: Post.dummy(), comments: .constant([]), replyingCommentID: .constant(String.randomString(length: 10)), replyingNickname: .constant(nil), newlyAddedComment: .constant(nil))
    }
}
