//
//  PostDetailLowerView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/26.
//

import SwiftUI

struct PostDetailLowerView: View {
    
    let post: Post
    
    @Binding private var comments: [Comment]?
    @Binding private var replyingCommentID: String?
    
    @State private var text: String = ""
    @State private var viewHeight: CGFloat = 60
    @State private var backgroundNeedsHighlight = false
    
    init(post: Post, comments: Binding<[Comment]?>, replyingCommentID: Binding<String?>) {
        self.post = post
        self._comments = comments
        self._replyingCommentID = replyingCommentID
    }
    
    var body: some View {
        VStack {
            if replyingCommentID != nil {
                EmptyView()
                    .frame(height: 8, alignment: .top)
            }
            
            HStack(spacing: 8) {
                VStack {
                    Spacer(minLength: 0)
                        .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                    AsyncImage(url: URL(string: post.profileImageURL ?? "")) { image in
                        image.resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())

                    } placeholder: {
                        ProgressView()
                            .frame(width: 40, height: 40)
                    }
                }

                HStack(spacing: 8) {

                    TextEditorView(text: $text, textEditorHeight: $viewHeight, backgroundNeedsHighlight: $backgroundNeedsHighlight)

                    VStack {
                        Spacer(minLength: 0)
                            .frame(height: viewHeight - 50 > 0 ? viewHeight - 50 : 0)
                        Image("sendButton")
                            .padding(EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 16))
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            backgroundNeedsHighlight ? .appColor(.primary500) : Color.appColor(.neutral900).opacity(0.1),
                            lineWidth: backgroundNeedsHighlight ? 1 : 1
                        )
                        .shadow(
                            color: backgroundNeedsHighlight ? Color.clear : Color.black.opacity(0.1),
                            radius: 7,
                            x: 0,
                            y: 0
                        )
                )
            }
        }
    }
}

struct PostDetailLowerView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailLowerView(post: Post.dummy(), comments: .constant(nil), replyingCommentID: .constant(String.randomString(length: 10)))
    }
}
