//
//  CommunityView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI
import Combine

struct CommunityView<ViewModel: CommunityPostsManagable>: ContentView {
    @Binding var isTabBarHidden: Bool
    @StateObject private var viewModel: ViewModel
    @State private var isViewDidLoad: Bool = false
    @State private var isModalPresented = false
    @State private var isDetailViewActive = false
    @State private var needsRefresh = false
    @State private var detailViewNeedsRefresh = false
    @State private var nowLookingPostID = ""
    
    init(isTabBarHidden: Binding<Bool>, viewModel: ViewModel) {
        _isTabBarHidden = isTabBarHidden
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                navigationBar()
                
                ScrollView(.vertical, showsIndicators: false) {
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
                    if !isViewDidLoad {
//                    for _ in (1...3) {
//                        try await FirebasePostManager().uploadNewPost(Post.dummy(), with: nil)
//                    }
                        await fetch10Posts()
                        isViewDidLoad = true
                    }
                }
                withAnimation(.easeInOut) {
                    isTabBarHidden = false
                }
            }
            .onChange(of: needsRefresh) { needsRefresh in
                Task {
                    if needsRefresh {
                        await refresh()
                        self.needsRefresh = false
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .fullScreenCover(isPresented: $isModalPresented) {
            PostFillingView(postID: $nowLookingPostID, isPresented: $isModalPresented, communityViewNeedsRefresh: $needsRefresh, detailViewNeedsRefresh: $detailViewNeedsRefresh)
        }
    }
    
    @ViewBuilder
    private func navigationBar() -> some View {
        HStack {
            Spacer()
            
            Button {
                showPostFillingView()
            } label: {
                Image("edit")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
            }
            
            NavigationLink(destination: NotificationView(isTabBarHidden: $isTabBarHidden)) {
                Image("notification")
            }
            .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 16))
        }
    }
    
    @ViewBuilder
    private func postView(for post: Post) -> some View {
        if post.isWeirdPost {
            PostView(post: post)
        } else {
            NavigationLink(destination: PostDetailView(postID: post.id, isTabBarHidden: $isTabBarHidden, isModalPresented: $isModalPresented, nowLookingPostID: $nowLookingPostID, needsUpperViewRefresh: $detailViewNeedsRefresh, communityViewNeedsRefresh: $needsRefresh)) {
                PostView(post: post)
            }
        }
    }

    private func postShadowColor(for post: Post) -> Color {
        return post.isAboutMoney ? Color("primary500").opacity(0.1) : Color.black.opacity(0.1)
    }
    
    private func showPostFillingView() {
        nowLookingPostID = ""
        isModalPresented = true
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

struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(isTabBarHidden: .constant(false), viewModel: CommunityViewModel())
    }
}


struct ListSelectionStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray : Color.clear)
    }
}
