//
//  CommentedPostsViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/16.
//

import Foundation

class CommentedPostsViewModel: CommunityPostsManagable {
    var postManager: PostManagable = FirebasePostManager()
    var isEndOfList = false
    var isBusy = false
    
    @Published var posts: [Post] = []
    
    func fetch10Posts() async throws {
        isBusy = true
        let newPosts = try await postManager.fetchUserCommentedPosts()
        
        isEndOfList = newPosts.count < 10 ? true : false
        
        DispatchQueue.main.sync {
            self.posts = newPosts
        }
        
        isBusy = false
    }
    
    func thisIsTheThirdLast(_ post: Post) -> Bool {
        guard !isEndOfList, !isBusy else { return false }
        
        let thirdLastElement = posts[posts.count - 3]
        return post == thirdLastElement
    }
    
    func removePosts() {
        postManager.removeLocalPosts()
        posts = []
    }
}
