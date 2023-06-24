//
//  PostFillingView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI

struct PostFillingView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @Binding var postID: String?
    @Binding var isPresented: Bool
    @State private var isAboutMoney: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var imageURL: [String]?
    @State private var selectedImage: UIImage?
    @FocusState private var isTextEditorFocused: Bool
    @State private var editorHeight: CGFloat = 300
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                HStack {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "xmark")
                            .tint(.appColor(.neutral900))
                    }

                    Spacer()
                    Button(action: {
                        Task {
                            do {
                                if let postID = postID, !postID.isEmpty {
                                    try await updatePost()
                                } else {
                                    try await uploadPost()
                                }
                            } catch {
                                print("등록 또는 수정 실패")
                            }
                        }
                        
                        presentationMode.wrappedValue.dismiss()
                        
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
                
                HStack {
                    Text("오늘의 지출 내역에 대한 이야기인가요?")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.appColor(.neutral700))
                    Spacer()
                    Toggle("", isOn: $isAboutMoney)
                        .tint(.appColor(.primary500))
                        .scaleEffect(0.5)
                        .labelsHidden()
                }
                .frame(maxWidth: .infinity)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: -5, trailing: -10))
                    
                ZStack(alignment: .leading) {
                    TextField("제목", text: $title)
                        .padding(.horizontal, isAboutMoney ? 40 : 16)
                        .frame(height: 48)
                        .foregroundColor(title == "" ? .appColor(.neutral600) : .appColor(.neutral900))
                        .font(.system(size: 18, weight: .bold))
                        .background(isAboutMoney ? Color.appColor(.primary050) : Color.appColor(.neutral050))
                        .cornerRadius(12)
                        .animation(.easeInOut, value: isAboutMoney)
                    
                    if isAboutMoney {
                        Image("stamp")
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
                    }
                }
                
                PostFillingCenterView(content: $content, isAboutMoney: $isAboutMoney, image: $selectedImage)
                    .padding(.bottom, 16)
                
                Text("어푸어푸는 깨끗한 커뮤니티를 만들기 위해 비방, 욕설, 광고, 명의 도용, 권리 침해, 음란성 내용의 게시글 등 타인에게 피해를 주거나 주제에 맞지 않는 게시글이라고 판단될 경우 삭제 조치할 수 있습니다. 지속적인 위반 시 서비스 이용이 일정 기간 제한될 수 있습니다.")
                    .foregroundColor(.appColor(.neutral600))
                    .modifier(FittingFontSizeModifier())
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 16)
        }
        .onAppear {
            Task {
                do {
                    if let postID = postID, !postID.isEmpty {
                        let post = try await MockPostManager.shared.fetchPost(postID: postID)
                        
                        title = post.title
                        content = post.body
                        imageURL = post.imageURL
                        
//                        default 이미지 디자인 받아서 나중에 올려줘야할 듯.
                        let url = URL(string: imageURL?.first ?? "")!
                        
                        selectedImage = try await ImageDownloadManager().downloadImageAndSaveAsUIImage(url: url)
                    }
                } catch {
                    print("포스트 불러오기 실패")
                }
            }
        }
    }
    
    private func uploadPost() async throws {
        guard let user = User.currentUser else { throw FirebaseError.userNotFound}
        let post = Post(id: "", userID: user.uid, nickName: user.nickName, profileImageURL: user.profileImageURL, isAboutMoney: isAboutMoney, title: title, body: content, timeStamp: Date(), likeCount: 0, commentCount: 0, isWeirdPost: false, imageURL: nil, comments: nil)
        
        try await FirebasePostManager().uploadNewPost(post, with: selectedImage)
    }
    
    private func updatePost() async throws {
//        타이틀, 본문, 돈얘기여부 제외하고는 업데이트를하지 않아서 아무값이나 넣어줘도 됨
        let post = Post(id: postID!, userID: "", nickName: "", profileImageURL: nil, isAboutMoney: isAboutMoney, title: title, body: content, timeStamp: Date(), likeCount: 0, commentCount: 0, isWeirdPost: false, imageURL: imageURL, comments: nil)
        try await FirebasePostManager().updatePost(post, with: selectedImage)
    }
}

struct PostFillingView_Previews: PreviewProvider {
    static var previews: some View {
    
        PostFillingView(postID: .constant(""), isPresented: .constant(true))
    }
}

struct FittingFontSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 12))
      .minimumScaleFactor(0.001)
  }
}
