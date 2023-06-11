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
    @State var post: Post?
    @State var comments: [Comment]?
    
    init(postID: String) {
        self.postID = postID
        
        let appearance = UINavigationBarAppearance()
        appearance.shadowColor = .clear
        appearance.backgroundColor = .systemBackground
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        VStack {
            if let post = post {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
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
                    
                    if let comments = self.comments {
                        VStack {
                            ForEach(comments.indices, id: \.self) { index in
                                let comment = comments[index]
                                
                                if index != 0 && comment.belongingCommentID == nil {
                                    Rectangle()
                                        .frame(height: 1)
                                        .foregroundColor(.appColor(.neutral100))
                                }
                                CommentView(comment: comment)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                                    .padding(.leading, comment.belongingCommentID == nil ?  0 : 35)
                            }
                        }
                    }
                }
                
                PostDetailLowerView(post: post)
            } else {
                ProgressView()
            }
        }
        .padding(EdgeInsets(top: 0, leading: 18, bottom: 16, trailing: 18))
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: BackButton(presentationMode: presentationMode))
        .onAppear {
            Task {
                post = try await MockPostManager.shared.fetchPost(postID: "")
                
                comments = rearrangeComments(
                    post?.comments
                    ??
                    [Comment]()
                )
            }
        }
    }
    
    func rearrangeComments(_ comments: [Comment]) -> [Comment] {
        let commentsWithBelongingID =
        comments
            .filter { $0.belongingCommentID != nil }
            .sorted { lhs, rhs in
            lhs.timeStamp < rhs.timeStamp
        }
        
        let commentsWithoutBelongingID =
        comments
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
        
        return reArrangedComments
    }
}

struct PostDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PostDetailView(postID: "")
    }
}
