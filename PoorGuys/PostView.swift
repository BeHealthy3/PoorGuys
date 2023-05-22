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
            HStack {
                VStack(alignment: .leading) {
                    Text(post.title)
                        .font(.title)
                    Text(post.body)
                        .font(.subheadline)
                }
                Spacer()
                
                let imageURL = URL(string: post.imageURL?.first ?? "")
                
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 50, height: 50)
            }
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: Post.dummyPost())
    }
}
