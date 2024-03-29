//
//  LikedPostsView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/15.
//

import SwiftUI

struct LikedPostsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isViewLoaded = false
    @State private var isModalPresented = false
    @State private var isDetailViewActive = false
    @State private var needsRefresh = false
    @State private var detailViewNeedsRefresh = false
    @State private var nowLookingPostID = ""
    @StateObject var viewModel = LikedPostsViewModel()
    
    var body: some View {
        VStack {
            navigationHeader()
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.posts, id: \.id) { post in
                        postView(for: post)
                            .task { await fetch10PostsIfThisPostsIsLastThird(post: post) }
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(color: postShadowColor(for: post), radius: 7, x: 0, y: 0)
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
            }
            .refreshable {
                await refresh()
            }
        }
        .onAppear {
            Task {
                if !isViewLoaded {
                    await fetch10Posts()
                    isViewLoaded = true
                } else {
                    await refresh()
                }
            }
        }
        .onChange(of: needsRefresh, perform: { needsRefresh in
            Task {
                if needsRefresh {
                    await refresh()
                    self.needsRefresh = false
                }
            }
        })
        
        .navigationBarHidden(true)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    @ViewBuilder
    func navigationHeader() -> some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.left")
                }
                .padding(.leading, 16)
                .padding(.vertical, 12)
                Spacer()
            }
            Text("적선한 게시글")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
        }
    }
    
    @ViewBuilder
    private func postView(for post: Post) -> some View {
        if post.isWeirdPost {
            PostView(post: post)
        } else {
            NavigationLink(destination: PostDetailView(postID: post.id, isModalPresented: $isModalPresented, nowLookingPostID: $nowLookingPostID, needsUpperViewRefresh: $detailViewNeedsRefresh, communityViewNeedsRefresh: $needsRefresh)) {
                PostView(post: post)
            }
        }
    }
    
    private func postShadowColor(for post: Post) -> Color {
        return post.isAboutMoney ? Color("primary500").opacity(0.1) : Color.black.opacity(0.1)
    }
    
    private func fetch10PostsIfThisPostsIsLastThird(post: Post) async {
        if viewModel.thisIsTheThirdLast(post) {
            await fetch10Posts()
        }
    }
    
    private func refresh() async {
        viewModel.removePosts()
        await fetch10Posts()
    }
    
    private func fetch10Posts() async {
        do {
            try await viewModel.fetch10Posts()
        } catch {
            print("포스팅 패치 실패")
        }
    }
}

struct LikedPostsView_Previews: PreviewProvider {
    static var previews: some View {
        LikedPostsView()
    }
}
