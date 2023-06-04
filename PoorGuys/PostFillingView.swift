//
//  PostFillingView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI
import Kingfisher

struct PostFillingView: View {

    @Binding var postID: String?
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
                    if let postID = postID {
                        let post = try await MockPostManager.shared.fetchPost(postID: postID)
                        
                        title = post.title
                        content = post.body
                        imageURL = post.imageURL?.first
                        
                        let url = URL(string: imageURL ?? "")!
                        
                        selectedImage = try await ImageDownloadManager().downloadImageAndSaveAsUIImage(url: url)
                    }
                } catch {
                    
                }
            }
        }
    }
}

struct PostFillingView_Previews: PreviewProvider {
    static var previews: some View {
    
        PostFillingView(postID: .constant(""))
    }
}
