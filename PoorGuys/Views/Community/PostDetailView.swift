//
//  PostDetailView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/24.
//

import SwiftUI
import Combine

struct PostDetailView: View {
    let postID: String
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var post: Post?
    @State private var comments = [Comment]()
    @State private var replyingCommentID: String? = nil
    @State private var replyingNickname: String? = nil
    @State private var isCommentLikeButtonEnabled = true
    @State private var newlyAddedComment: Comment?
    @State private var needsRefresh = true
    
    @Binding private var nowLookingPostID: ID
    @Binding private var isModalPresented: Bool
    
    init(postID: String, isModalPresented: Binding<Bool>, nowLookingPostID: Binding<ID>) {
        self.postID = postID
        _isModalPresented = isModalPresented
        _nowLookingPostID = nowLookingPostID
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            VStack(spacing: replyingNickname == nil ? 16 : 0) {
                if let post = post {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack {
                            PostDetailUpperView(post: post, needsRefresh: $needsRefresh, isModalPresented: $isModalPresented, nowLookingPostID: $nowLookingPostID)
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
                        
                        if !comments.isEmpty {
                            VStack {
                                ForEach(comments) { comment in // comments를 직접 사용하여 ForEach 뷰를 생성
                                    if comment.belongingCommentID == nil, comment != comments.first {
                                        Rectangle()
                                            .frame(height: 1)
                                            .foregroundColor(.appColor(.neutral100))
                                    }
                                    CommentView(post: $post, comments: $comments, comment: comment, replyingCommentID: $replyingCommentID, replyingNickName: $replyingNickname, isLikeButtonEnabled: $isCommentLikeButtonEnabled)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                        .padding(.leading, comment.belongingCommentID == nil ?  0 : 35)
                                        .id(comments.firstIndex(of: comment))
                                }
                                .transition(.slide)
                            }
                        }
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 0)
                    
                    if let replyingNickname = replyingNickname {
                        VStack(spacing: 0) {
                            HStack {
                                Text("\(replyingNickname)님에게 답글을 남기는 중")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(Color.appColor(.neutral600))
                                
                                Spacer()
                                
                                Button {
                                    self.replyingNickname = nil
                                    self.replyingCommentID = nil
                                } label: {
                                    Image("xmark")
                                        .renderingMode(.template)
                                        .foregroundColor(Color.appColor(.neutral600))
                                        .frame(width: 24, height: 24)
                                }
                            }
                            .padding(.all, 10)
                            .background(Color.appColor(.neutral050))
                            
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(.appColor(.neutral200))
                        }
                    }
                    
                    PostDetailLowerView(post: post, comments: $comments, replyingCommentID: $replyingCommentID, replyingNickname: $replyingNickname, newlyAddedComment: $newlyAddedComment)
                        .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
                } else {
                    ProgressView()
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarItems(leading: BackButton(presentationMode: presentationMode))
            .onAppear {
                Task {
                    post = try await FirebasePostManager().fetchPost(postID: postID)
                    comments = post?.comments ?? []
//                    needsRefresh = false
                    print(nowLookingPostID, "📱")
                    nowLookingPostID = postID
                    print(nowLookingPostID,"📱📱")
                }
            }
            .onChange(of: comments) { _ in
                rearrangeComments()
                scrollToComment(proxy: proxy)
            }
        }
    }
    
    func rearrangeComments() {
        let unfilteredComments = comments
        let commentsWithBelongingID = unfilteredComments
            .filter { $0.belongingCommentID != nil }
            .sorted { lhs, rhs in
            lhs.timeStamp < rhs.timeStamp
        }
        
        let commentsWithoutBelongingID = unfilteredComments
            .filter { $0.belongingCommentID == nil }
            .sorted { lhs, rhs in
            lhs.timeStamp < rhs.timeStamp
        }
        
        var reArrangedComments = [Comment]()
        
        for commentWithoutBelongingID in commentsWithoutBelongingID {
            reArrangedComments.append(commentWithoutBelongingID)
            for commentWithBelongingID in commentsWithBelongingID {
                if commentWithBelongingID.belongingCommentID == commentWithoutBelongingID.id {
                    reArrangedComments.append(commentWithBelongingID)
                }
            }
        }
        self.comments = reArrangedComments
    }
    
    private func scrollToComment(proxy: ScrollViewProxy) {
        guard let newlyAddedComment = newlyAddedComment,
              let newlyAddedCommentIndex = comments.firstIndex(of: newlyAddedComment) else { return }
        
        scrollToView(proxy, index: newlyAddedCommentIndex)
    }
    
    private func scrollToView(_ proxy: ScrollViewProxy, index: Int) {
        withAnimation {
            proxy.scrollTo(index, anchor: .bottom)
        }
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(postID: "", isModalPresented: .constant(false), nowLookingPostID: .constant(""))
    }
}

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                return keyboardFrame.height
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                0
            }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}

private func scrollToView(_ proxy: ScrollViewProxy, index: Int) {
        withAnimation {
            proxy.scrollTo(index, anchor: .top)
        }
    }
