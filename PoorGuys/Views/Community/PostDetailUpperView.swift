//
//  PostDetailUpperView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailUpperView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showingSheet = false
    @State private var isModalPresented = false
    
    let post: Post
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                AsyncImage(url: URL(string: post.profileImageURL ?? "")) { image in
                    image.resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    
                } placeholder: {
                    ProgressView()
                        .frame(width: 40, height: 40)
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
                        if User.currentUser?.uid == post.userID {
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
                                print("신고하기")
                            } label: {
                                Text("신고하기")
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
            
            AsyncImage(url: URL(string: post.imageURL?.first ?? "")) { image in
                image.resizable()
                    .frame(width: 311, height: 311)
            } placeholder: {
                ProgressView()
                    .frame(width: 311, height: 311)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(DateFormatter().excludeYear(from: post.timeStamp))
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.appColor(.neutral100))
                
                HStack(spacing: 64) {
                    Button {
                        print("적선")
                    } label: {
                        HStack {
                            Image("like")
                                .frame(width: 16, height: 16)
                            Text("적선하기")
                                .font(.system(size: 11))
                        }
                    }
                    
                    Button {
                        print("댓글")
                    } label: {
                        HStack {
                            Image("comment")
                                .frame(width: 16, height: 16)
                            Text("댓글쓰기")
                                .font(.system(size: 11))
                        }
                    }
                    
                    Button {
                        print("신고")
                    } label: {
                        HStack {
                            Image("siren")
                                .frame(width: 16, height: 16)
                            Text("신고하기")
                                .font(.system(size: 11))
                        }
                    }
                }
                .foregroundColor(.appColor(.neutral600))
            }
            
//            HStack() {
//                Spacer()
//                HStack(spacing: 8) {
//                    HStack(spacing: 2) {
//                        Image("comments")
//                        Text(String(post.commentCount))
//                            .foregroundColor(.appColor(.secondary))
//                    }
//
//                    HStack(spacing: 2) {
//                        Image("thumbsUp")
//                        Text(String(post.likeCount))
//                            .foregroundColor(.appColor(.primary300))
//                    }
//                }
//            }
//            .font(.system(size: 11))
//            .foregroundColor(.gray)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}

struct PostDetailUpperView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailUpperView(post: Post.dummy())
    }
}
