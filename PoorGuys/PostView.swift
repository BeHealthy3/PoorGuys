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
                HStack() {
                    
                    VStack(alignment: .leading, spacing: 9) {
                        HStack(spacing: 8) {
                            Image("stamp")

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
                .font(.system(size: 11))
                .foregroundColor(.gray)
            }
        }
    }
}

//struct PostView: View {
//    let post: Post
//
//    var body: some View {
//        HStack(alignment: .top, spacing: 10) {
//            Image(systemName: "circle")
//                .resizable()
//                .frame(width: 10, height: 10)
//                .foregroundColor(.blue)
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(post.title)
//                    .font(.headline)
//
//                Text(post.content)
//                    .lineLimit(2)
//                    .font(.body)
//
//                if let image = post.image {
//                    AsyncImage(image: image)
//                        .frame(width: 80, height: 80)
//                        .cornerRadius(8)
//                }
//            }
//
//            Spacer()
//
//            VStack(alignment: .trailing, spacing: 4) {
//                Text(post.author)
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//
//                Text(post.timestamp, style: .relative)
//                    .font(.caption)
//                    .foregroundColor(.gray)
//
//                HStack(spacing: 4) {
//                    Image(systemName: "hand.thumbsup")
//                        .foregroundColor(.green)
//                    Text("\(post.likes)")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//
//                    Image(systemName: "bubble.right")
//                        .foregroundColor(.blue)
//                    Text("\(post.comments)")
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//        }
//        .padding(.vertical, 8)
//    }
//}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.dummyPost())
    }
}
