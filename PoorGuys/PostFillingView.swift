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
                    .padding(.vertical, 10)
                    .cornerRadius(12)
                
                PostFillingCenterView(content: $content, imageURL: $imageURL, image: $selectedImage)
                    .padding(.bottom, 16)
                
                Text("어푸어푸는 누구나 기분 좋게 참여할 수 있는 커뮤니티를 만들기 위해 커뮤니티 이용규칙을 제정하여 운영하고 있습니다. 위반 시 게시글이 삭제되고 서비스 이용이 일정 기간 제한될 수 있습니다.")
                    .foregroundColor(.appColor(.neutral600))
                    .modifier(FittingFontSizeModifier())
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
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
                    print("포스트 불러오기 실패")
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

struct FittingFontSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 12))
      .minimumScaleFactor(0.001)
  }
}
