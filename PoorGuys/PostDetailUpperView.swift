//
//  PostDetailUpperView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailUpperView: View {
    
    @State var showingSheet = false
    
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
                }

                Text(post.nickName)
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
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    if post.isAboutMoney {
                        Image("stamp")
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
            }

            
                
            HStack() {
                Text(DateFormatter().excludeYear(from: post.timeStamp))
                Spacer()
                HStack(spacing: 8) {
                    HStack(spacing: 2) {
                        Image("comments")
                        Text(String(post.commentCount))
                            .foregroundColor(.appColor(.secondary))
                    }
                    
                    HStack(spacing: 2) {
                        Image("thumbsUp")
                        Text(String(post.likeCount))
                            .foregroundColor(.appColor(.primary300))
                    }
                }
            }
            .font(.system(size: 11))
            .foregroundColor(.gray)
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
}

struct PostDetailUpperView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailUpperView(post: Post.dummyPost())
    }
}
