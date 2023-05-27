//
//  PostDetailView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/24.
//

import SwiftUI

struct PostDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let post: Post
    
    init(post: Post) {
        self.post = post
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            ScrollView {
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
            PostDetailLowerView(post: post)
        }
        .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton(presentationMode: presentationMode))
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(post: Post.dummyPost())
    }
}
