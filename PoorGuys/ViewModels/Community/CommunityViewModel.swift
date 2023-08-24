//
//  CommunityViewModel.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/06/21.
//

import Foundation

class CommunityViewModel: CommunityPostsManagable {
    
    var postManager: PostManagable = FirebasePostManager()
    var isEndOfList = false
    var isBusy = false
    
    @Published var posts: [Post] = []
    
    func fetch10Posts() async throws {
        isBusy = true
        
        let newPosts = try await postManager.fetch10Posts()
        
        isEndOfList = newPosts.count < 10 ? true : false
        
        DispatchQueue.main.async {
            self.posts += newPosts
        }
        
        isBusy = false
    }
    
    func removePosts() {
        postManager.removeLocalPosts()
        posts = []
    }
    
    func thisIsTheThirdLast(_ post: Post) -> Bool {
        guard !isEndOfList, !isBusy else { return false }
        
        let thirdLastElement = posts[posts.count - 3]
        return post == thirdLastElement
    }
}
