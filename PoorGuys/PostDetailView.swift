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
                Image("sendButton")
            }
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
