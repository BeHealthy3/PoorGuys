//
//  PostDetailView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/24.
//

import SwiftUI

struct PostDetailView: View {
    
    let post: Post
    
    var body: some View {
        Text(post.id)
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: Post.dummyPost())
    }
}
