//
//  PostView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI

struct PostView: View {

    let post: Post

    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        ZStack {
            if post.isWeirdPost {
                Color.white
                Text("신고에 의해 관리자가 가린 게시글 입니다.")
                    .foregroundColor(.appColor(.neutral600))
                    .font(.system(size: 14, weight: .bold))
                    .position(x: 125, y: 22)
                    .frame(height: 78)
            } else {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(alignment: .top, spacing: 20) {
                            
                            VStack(alignment: .leading, spacing: 9) {
                                HStack(spacing: 8) {
                                    if post.isAboutMoney {
                                        Image("stamp")
                                    }

                                    Text(post.title)
                                        .frame(alignment: .leading)
                                        .lineLimit(1)
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.appColor(.neutral900))
                                        
                                }
                                Text(post.body)
                                    .frame(minWidth: 0, maxHeight: .infinity, alignment: .leading)
                                    .lineLimit(2)
                                    .multilineTextAlignment(.leading)
                                    .font(.system(size: 12))
                                    .foregroundColor(.appColor(.neutral800))
                            }
                            
                            if let strImageURL = post.imageURL?.first, strImageURL != "", let imageURL = URL(string: strImageURL) {
                                
                                AsyncImage(url: imageURL) { image in
                                    image
                                        .resizable()
                                        .frame(width: 60, height: 60, alignment: .trailing)
                                        .cornerRadius(12)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 60, height: 60)
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 18, leading: 16, bottom: 16, trailing: 16))
                        HStack() {
                            HStack(spacing: 4) {
                                Text(post.nickName)
                                Text(post.timeStamp.formatted().prefix(4))
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            
                            HStack(spacing: 8) {
                                HStack(spacing: 2) {
                                    Image("comments")
                                    Text(String(post.comments.count ?? 0))
                                        .foregroundColor(.appColor(.secondary))
                                }
                                
                                HStack(spacing: 2) {
                                    Image("thumbsUp")
                                    Text(String(post.likedUserIDs.count))
                                        .foregroundColor(.appColor(.primary300))
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 16, bottom: 8, trailing: 16))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.dummy())
    }
}
