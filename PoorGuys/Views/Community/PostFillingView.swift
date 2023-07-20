//
//  PostFillingView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/29.
//

import SwiftUI

struct PostFillingView: View {

    @Binding var postID: ID
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var isPresented: Bool
    @Binding var needsRefresh: Bool
    
    @FocusState private var isTextEditorFocused: Bool
    @State private var isAboutMoney: Bool = false
    @State private var title: String = ""
    @State private var content: String = ""
    @State private var imageURL: [String]?
    @State private var selectedImage: UIImage?
    @State private var editorHeight: CGFloat = 300
    @State private var showAlert = false
    @State private var alertMessage: PostFillingViewAlertMessage = .fillContents
    
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
                        if !title.isEmpty && !content.isEmpty {
                            Task {
                                do {
                                    if !postID.isEmpty {
                                        print("😂")
                                        try await updatePost()
                                    } else {
                                        print("😂😂")
                                        try await uploadPost()
                                    }
                                    
                                    needsRefresh = true
                                    presentationMode.wrappedValue.dismiss()
                                    
                                } catch {
                                    alertMessage = .uploadFailed
                                    showAlert = true
                                }
                            }
                        } else {
                            alertMessage = .fillContents
                            showAlert = true
                        }
                    }) {
                        Text("등록")
                            .foregroundColor(.white)
                            .font(.system(size: 14, weight: .bold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.appColor(.primary500))
                            .cornerRadius(12)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("알림"), message: Text(alertMessage.rawValue), dismissButton: .default(Text("확인")))
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
                    print(postID, postID.isEmpty,"❤️")
                    if !postID.isEmpty {
                        print("🍓")
                        let post = try await FirebasePostManager().fetchPost(postID: postID)
                        print("🍓🍓")
                        title = post.title
                        content = post.body
                        imageURL = post.imageURL
                        
//                        default 이미지 디자인 받아서 나중에 올려줘야할 듯.
                        if let imageURL = imageURL?.first {
                            let url = URL(string: imageURL)!
                            selectedImage = try await ImageDownloadManager().downloadImageAndSaveAsUIImage(url: url)
                        }
                    }
                } catch {
                    print("포스트 불러오기 실패")
                }
            }
        }
    }
    
    private func uploadPost() async throws {
//        guard let user = User.currentUser else { throw FirebaseError.userNotFound}
        let user = User.currentUser!    //🚨todo: user바꾸기
        let post = Post(id: "", userID: user.uid, nickName: user.nickName, profileImageURL: user.profileImageURL, isAboutMoney: isAboutMoney, title: title, body: content, timeStamp: Date(), likedUserIDs: [], isWeirdPost: false, imageURL: [], comments: [])
        
        try await FirebasePostManager().uploadNewPost(post, with: selectedImage)
    }
    
    private func updatePost() async throws {
//        타이틀, 본문, 돈얘기여부 제외하고는 업데이트를하지 않아서 아무값이나 넣어줘도 됨
        let post = Post(id: postID, userID: "", nickName: "", profileImageURL: nil, isAboutMoney: isAboutMoney, title: title, body: content, timeStamp: Date(), likedUserIDs: [], isWeirdPost: false, imageURL: [], comments: [])
        try await FirebasePostManager().updatePost(post, with: selectedImage)
    }
}

struct PostFillingView_Previews: PreviewProvider {
    static var previews: some View {
    
        PostFillingView(postID: .constant(""), isPresented: .constant(true), needsRefresh: .constant(false))
    }
}

struct FittingFontSizeModifier: ViewModifier {
  func body(content: Content) -> some View {
    content
      .font(.system(size: 12))
      .minimumScaleFactor(0.001)
  }
}

enum PostFillingViewAlertMessage: String {
    case uploadFailed = "게시글 업로드에 실패했습니다.\n 다시 시도해주세요."
    case fillContents = "제목과 내용을 작성해 주세요"
}
