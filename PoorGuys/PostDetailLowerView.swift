//
//  PostDetailLowerView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailLowerView: View {
    
    let post: Post
    
    @State private var text: String = ""
    
    var body: some View {
        HStack(spacing: 8) {
            AsyncImage(url: URL(string: post.profileImageURL ?? "")) { image in
                image.resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
            } placeholder: {
                ProgressView()
            }

            HStack(spacing: 8) {
                TextField("댓글 쓰기", text: $text)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .bold))
                    .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 0))
                    .foregroundColor(.appColor(.neutral900))
                
                Image("sendButton")
                    .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 16))
            }
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeShadow(
                            color:  Color.appColor(.neutral900).opacity(0.1),
                            radius: 7,
                            x: 0,
                            y: 0
                        )
                )
        }
    }
}

struct PostDetailLowerView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailLowerView(post: Post.dummyPost())
    }
}
