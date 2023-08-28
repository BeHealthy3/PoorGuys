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
    @State private var post: Post?
    @State private var comments = [Comment]()
    @State private var replyingCommentID: String? = nil
    @State private var replyingNickname: String? = nil
    @State private var isCommentLikeButtonEnabled = true
    @State private var newlyAddedComment: Comment?
    
    @Binding private var nowLookingPostID: ID
    @Binding private var isModalPresented: Bool
    @Binding private var needsUpperViewRefresh:Bool
    @Binding private var communityViewNeedsRefresh: Bool
    
    init(postID: String, isModalPresented: Binding<Bool>, nowLookingPostID: Binding<ID>, needsUpperViewRefresh: Binding<Bool>, communityViewNeedsRefresh: Binding<Bool>) {
        self.postID = postID
        _isModalPresented = isModalPresented
        _nowLookingPostID = nowLookingPostID
        _needsUpperViewRefresh = needsUpperViewRefresh
        _communityViewNeedsRefresh = communityViewNeedsRefresh
        
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
                        PostDetailUpperView(post: post, isModalPresented: $isModalPresented, nowLookingPostID: $nowLookingPostID, upperViewNeedsRefresh: $needsUpperViewRefresh, communityViewNeedsRefresh: $communityViewNeedsRefresh)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeShadow(
                                        color: post.isAboutMoney && !post.isWeirdPost ?
                                        Color.appColor(.primary500).opacity(0.1) : Color.appColor(.neutral900).opacity(0.1), radius: 7, x: 0, y: 0)
                            )
                        
                        ForEach(comments) { comment in
                            
                            Rectangle()
                                .onlyIf(comment.belongingCommentID == nil && comment != comments.first)
                                .frame(height: 1)
                                .foregroundColor(.appColor(.neutral100))
                            
                            CommentView(post: $post, comments: $comments, comment: comment, replyingCommentID: $replyingCommentID, replyingNickName: $replyingNickname, isLikeButtonEnabled: $isCommentLikeButtonEnabled)
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                .padding(.leading, comment.belongingCommentID == nil ?  0 : 35)
                                .id(comments.firstIndex(of: comment))
                        }
                        .transition(.slide)
                        .onlyIf(!comments.isEmpty)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 0)
                    
                    if let replyingNickname = replyingNickname, replyingCommentID != nil {
                        isReplyingView(to: replyingNickname)
                    }
                    
                    PostDetailLowerView(post: post, comments: $comments, replyingCommentID: $replyingCommentID, replyingNickname: $replyingNickname, newlyAddedComment: $newlyAddedComment)
                        .padding(EdgeInsets(top: replyingCommentID == nil ? 0 : 16, leading: 18, bottom: 16, trailing: 18))
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
                    nowLookingPostID = postID
                }
            }
            .onChange(of: comments) { _ in
                rearrangeComments()
                scrollToComment(proxy: proxy)
            }
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
    
    @ViewBuilder
    private func isReplyingView(to replyingNickname: String) -> some View {
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
