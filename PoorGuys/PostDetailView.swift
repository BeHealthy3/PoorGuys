//
//  PostDetailView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/24.
//

import SwiftUI

struct PostDetailView: View {
    let postID: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var post: Post?
    
    init(postID: String) {
        self.postID = postID
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            if let post = post {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        PostDetailUpperView(post: post)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeShadow(
                                        color: post.isAboutMoney && !post.isWeirdPost ?
                                        Color.appColor(.primary500).opacity(0.1) : Color.appColor(.neutral900).opacity(0.1),
                                        radius: 7,
                                        x: 0,
                                        y: 0
                                    )
                            )
                    }
                    
                    if let comments = post.comments {
                        LazyVStack {
                            ForEach(comments) { comment in
                                CommentView(comment: comment)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(.appColor(.neutral100))
                            }
                        
                        }
                    }
                }
                
                PostDetailLowerView(post: post)
            } else {
                ProgressView()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton(presentationMode: presentationMode))
        .onAppear {
            Task {
                post = try await MockPostManager.shared.fetchPost(postID: "")
            }
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(postID: "")
    }
}
