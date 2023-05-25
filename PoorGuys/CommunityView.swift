//
//  CommunityView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/17.
//

import SwiftUI
import Combine

protocol CommunityPostsManagable: ObservableObject {
    
    var posts: [Post] { get set }
    
    func fetch20Posts() async
    func fetchNext10Posts(after post: Post) async
    func thisIsTheThirdLast(_ post: Post) -> Bool
}

extension CommunityPostsManagable {
    func removeFirst10Posts() {
        posts.removeFirst(10)
    }
    
    func removeLast10Posts() {
        posts.removeLast(10)
    }
}

class MockCommunityViewModel: CommunityPostsManagable {
    
    @Published var posts: [Post] = []
    
    func fetch20Posts() async {
        do {
            let newPosts = try await MockPostManager.shared.fetch20Posts()
            
            DispatchQueue.main.async {
                self.posts.insert(contentsOf: newPosts, at: 0)
            }
        } catch {
            
        }
    }
    
    func fetchNext10Posts(after post: Post) async {
        do {
            let newPosts = try await MockPostManager.shared.fetchNext10Posts(from: post)
            
            DispatchQueue.main.async {
                self.posts.insert(contentsOf: newPosts, at: self.posts.endIndex)
            }
        } catch {
            
        }
    }
    
    func thisIsTheThirdLast(_ post: Post) -> Bool {
        guard posts.count >= 3 else {
            // 배열의 크기가 3보다 작으면 끝에서 3번째 요소가 없으므로 false 반환
            return false
        }
        
        let thirdLastElement = posts[posts.count - 3]
        return post == thirdLastElement
    }
}

struct CommunityView<ViewModel: CommunityPostsManagable>: View {
    
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        
                    }, label: {
                        Image("edit")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    })
                    Button(action: {
                        
                    }, label: {
                        Image("profile")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                    })
                }
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        ForEach(viewModel.posts, id: \.id) { post in
                            if post.isWeirdPost {
                                PostView(post: post)
                                    .task {
                                        if viewModel.thisIsTheThirdLast(post) {
                                            await viewModel.fetchNext10Posts(after: post)
                                        }
                                    }
                                    .padding(5)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .shadow(color: post.isAboutMoney ? Color("primary500").opacity(0.1) : Color.black.opacity(0.1
                                                                                                                             ), radius: 7, x: 0, y: 0)
                                    .buttonStyle(.automatic)
                            } else {
                                NavigationLink(destination: PostDetailView(post: post), label: {
                                    PostView(post: post)
                                })
                                .task {
                                    if viewModel.thisIsTheThirdLast(post) {
                                        await viewModel.fetchNext10Posts(after: post)
                                    }
                                }
                                .padding(5)
                                .background(Color.white)
                                .cornerRadius(12)
                                .shadow(color: post.isAboutMoney ? Color("primary500").opacity(0.2) : Color.black.opacity(0.2), radius: 7, x: 0, y: 0)
                                .buttonStyle(.automatic)
                            }
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetch20Posts()
                }
            }
        }
    }
}


struct CommunityView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityView(viewModel: MockCommunityViewModel())
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
