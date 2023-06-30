//
//  CommentView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/28.
//

import SwiftUI

struct CommentView: View {
    
    private var postUserID: String
    
    @State var showingSheet = false
    
    private let comment: Comment
    @Binding private var replyingCommentID: String?
    @Binding private var replyingNickname: String?
    
    init(postUserID: String, comment: Comment, replyingCommentID: Binding<String?>, replyingNickName: Binding<String?>) {
        self.postUserID = postUserID
        self.comment = comment
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
                        
                        Text(comment.nickName + (postUserID == comment.userID ? " (작성자)" : ""))
                            .lineLimit(1)
                            .foregroundColor(postUserID == comment.userID ?
                                .appColor(.primary500) : .appColor(.neutral700))
                            .font(.system(size: 12, weight: .bold))
                            
                        Spacer()
                        Image("verticalEllipsis")
                            .onTapGesture {
                                showingSheet = true
                            }
                            .confirmationDialog("", isPresented: $showingSheet) {
                                Button {
                                    print("수정하기")
                                } label: {
                                    Text("수정하기")
                                }
                                Button {
                                    print("신고하기")
                                } label: {
                                    Text("신고하기")
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
                                
                                HStack(spacing: 4) {
                                    Image("thumbsUp")
                                        .renderingMode(.template)
                                        .foregroundColor(.appColor(.neutral500))
                                    Text(String(comment.likeCount))
                                        .foregroundColor(.appColor(.neutral500))
                                        .font(.system(size: 11))
                                }
                                .onTapGesture {
                                    print("좋아요")
                                }
                            }
                        }
                    }
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
//            if let replies = comment.replies {
//                VStack {
//                    ForEach(replies) { reply in
//                        ReplyView(reply: reply)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                    }
//                }
//            }
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        return CommentView(postUserID: "", comment: Comment.dummy(), replyingCommentID: .constant(""), replyingNickName: .constant(""))
    }
}
