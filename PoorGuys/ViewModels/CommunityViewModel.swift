//
//  CommunityViewModel.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/06/21.
//

import Foundation

protocol CommunityPostsManagable: ObservableObject {
    
    var postManager: PostManagable { get }
    
    var posts: [Post] { get set }
    
    func fetch10Posts() async throws
    func thisIsTheThirdLast(_ post: Post) -> Bool
    func removePosts()
}

class CommunityViewModel: CommunityPostsManagable {
    
    var postManager: PostManagable = FirebasePostManager()
    
    @Published var posts: [Post] = []
    
    func fetch10Posts() async throws {
        let newPosts = try await postManager.fetch10Posts()
        
        DispatchQueue.main.async {
            self.posts += newPosts
        }
    }
    
    func removePosts() {
        postManager.removeLocalPosts()
        posts = []
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
