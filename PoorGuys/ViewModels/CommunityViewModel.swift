//
//  CommunityViewModel.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/06/21.
//

import Foundation

protocol CommunityPostsManagable: ObservableObject {
    
    var postManager: PostManagable { get }
    var isEndOfList: Bool { get set }
    var posts: [Post] { get set }
    
    func fetch10Posts() async throws
    func thisIsTheThirdLast(_ post: Post) -> Bool
    func removePosts()
}

class CommunityViewModel: CommunityPostsManagable {
    
    var postManager: PostManagable = FirebasePostManager()
    var isEndOfList = false
    
    @Published var posts: [Post] = []
    
    func fetch10Posts() async throws {
        let newPosts = try await postManager.fetch10Posts()
        
        isEndOfList = newPosts.count < 10 ? true : false
        
        DispatchQueue.main.async {
            self.posts += newPosts
        }
    }
    
    func removePosts() {
        postManager.removeLocalPosts()
        posts = []
    }
    
    func thisIsTheThirdLast(_ post: Post) -> Bool {
        guard !isEndOfList else { return false }
        
        let thirdLastElement = posts[posts.count - 3]
        return post == thirdLastElement
    }
}
