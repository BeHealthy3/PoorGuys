//
//  PostFillingView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI

struct PostFillingView: View {

    @Binding var post: Post?
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var imageURL: String?
    @State private var selectedImage: UIImage?
    @FocusState private var isTextEditorFocused: Bool
    @State private var editorHeight: CGFloat = 300
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Image(systemName: "xmark")
                    Spacer()
                    Button(action: {
                        print("upload post")
                    }) {
                        Text("등록")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appColor(.primary500))
                            .cornerRadius(12)
                    }
                }

                TextField("제목", text: $title)
                    .padding(.horizontal, 16)
                    .frame(height: 48)
                    .foregroundColor(title == "" ? .appColor(.neutral600) : .appColor(.neutral900))
                    .font(.system(size: 18, weight: .bold))
                    .background(Color.appColor(.neutral050))
                    .padding(.vertical, 20)
                    .cornerRadius(12)
                
                PostFillingCenterView(content: $content, imageURL: $imageURL, image: $selectedImage)
//                if #available(iOS 16.0, *) {
//                    TextEditor(text: $content)
//                        .padding()
//                        .frame(maxWidth: .infinity, minHeight: 300)
//                        .multilineTextAlignment(.leading)
//                        .lineSpacing(10.0)
//                        .scrollContentBackground(.hidden)
//                        .background(.red)
//                } else {
//                    TextEditor(text: $content)
//                        .padding()
//                        .frame(maxWidth: .infinity, minHeight: 300)
//                        .multilineTextAlignment(.leading)
//                        .lineSpacing(10.0)
//                        .background(.red)
//                }
                
            }.padding(EdgeInsets(top: 12, leading: 16, bottom: 16, trailing: 16))
        }
        .onAppear {
            Task {
                do {
                    if let post = post {
                        self.post = try await MockPostManager.shared.fetchPost(postID: post.id)
                        title = self.post?.title ?? ""
                        content = self.post?.body ?? ""
                        imageURL = self.post?.imageURL?.first ?? ""
                    }
                } catch {
                    
                }
            }
        }
    }
}

struct PostFillingView_Previews: PreviewProvider {
    static var previews: some View {
    
        PostFillingView(post: .constant(nil))
    }
}
