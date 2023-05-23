//
//  PostView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI

struct PostView: View {

//    let imageURL = URL(string: "https://picsum.photos/200/300")!
    
    let post: Post

    init(post: Post) {
        self.post = post
    }
    
    var body: some View {
        VStack {
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    
                    VStack(alignment: .leading, spacing: 9) {
                        HStack(spacing: 8) {
                            if post.isAboutMoney {
                                Image("stamp")
                            }

                            Text(post.title)
                                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                .font(.system(size: 14, weight: .bold))
                                
                        }
                        Text(post.body)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .lineLimit(2)
                            .font(.system(size: 12))
                    }
                    
                    if let strImageURL = post.imageURL?.first, strImageURL != "", let imageURL = URL(string: strImageURL) {
                        
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .frame(width: 60, height: 60, alignment: .trailing)
                                .cornerRadius(12)
                        } placeholder: {
                            ProgressView()
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
                            Image("comment")
                            Text(String(post.commentCount))
                        }
                        
                        HStack(spacing: 2) {
                            Image("like")
                            Text(String(post.likeCount))
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

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.dummyPost())
    }
}
