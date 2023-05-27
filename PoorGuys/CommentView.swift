//
//  CommentView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/28.
//

import SwiftUI

struct CommentView: View {
    
    @State var showingSheet = false
    
    let comment: Comment
    
    var body: some View {
        if comment.isDeletedComment {
            HStack {
                Text("삭제된 댓글입니다.")
                    .foregroundColor(.appColor(.neutral600))
                Spacer()
            }
            .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
            
        } else {
            VStack(spacing: 4) {
                HStack(spacing: 8) {
                    AsyncImage(url: URL(string: comment.profileImageURL ?? "")) { image in
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                        
                    } placeholder: {
                        ProgressView()
                    }

                    Text(comment.nickName)
                        .lineLimit(1)
                        .foregroundColor(.appColor(.neutral700))
                        .font(.system(size: 12, weight: .bold
                                     ))
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
                    Spacer()
                }
                
                HStack() {
                    Text(DateFormatter().excludeYear(from: comment.timeStamp))
                    Spacer()
                    HStack(spacing: 8) {
                        
                        HStack(spacing: 8) {
                            Text("답글 쓰기")
                                .onTapGesture {
                                    print("답글쓰기")
                                }
                            HStack(spacing: 4) {
                                Image("thumbsUp")
                                    .renderingMode(.template)
                                    .foregroundColor(.appColor(.neutral500))
                                Text(String(comment.likeCount))
                                    .foregroundColor(.appColor(.neutral500))
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
            .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        }
    }
}

struct CommentView_Previews: PreviewProvider {
    static var previews: some View {
        return CommentView(comment: Comment.dummy())
    }
}
