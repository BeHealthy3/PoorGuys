//
//  CommunityView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI
import Combine

struct CommunityView<ViewModel: CommunityPostsManagable>: View {
    
    @StateObject private var viewModel: ViewModel
    @State private var isViewDidLoad: Bool = false
    @State private var isModalPresented = false
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button {
                        isModalPresented = true
                    } label: {
                        Image("edit")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    }
                    .fullScreenCover(isPresented: $isModalPresented) {
                        PostFillingView(postID: .constant(""), isPresented: $isModalPresented)
                    }
                    
                    Button(action: {
                        
                    }, label: {
                        Image("profile")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    })
                    .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 16))
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.posts, id: \.id) { post in
                            
                            if post.isWeirdPost {
                                PostView(post: post)
                                    .task { await fetchPostsTask(post: post) }
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: post.isAboutMoney && !post.isWeirdPost ?
                                            Color.appColor(.primary500).opacity(0.1) : Color.black.opacity(0.1), radius: 7, x: 0, y: 0)
                            } else {
                                NavigationLink(destination: PostDetailView(postID: post.id), label: {
                                    PostView(post: post)
                                })
                                .task { await fetchPostsTask(post: post) }
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: post.isAboutMoney ?
                                        Color("primary500").opacity(0.1) : Color.black.opacity(0.1), radius: 7, x: 0, y: 0)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .onAppear {
                if !isViewDidLoad {
                    Task {
                        await viewModel.fetch10Posts()
                        isViewDidLoad = true
                    }
                }
            }
        }
    }
    
    func fetchPostsTask(post: Post) async {
        if viewModel.thisIsTheThirdLast(post) {
            await viewModel.fetch10Posts()
        }
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(viewModel: CommunityViewModel())
    }
}

struct EmptyView: View {
    var body: some View {
        Text("")
            .buttonStyle(PlainButtonStyle())
    }
}


struct ListSelectionStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? Color.gray : Color.clear)
    }
}
