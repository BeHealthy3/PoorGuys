//
//  UserPostsViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/08/10.
//

import Foundation

class UserPostsViewModel: CommunityPostsManagable {
    var postManager: PostManagable = FirebasePostManager()
    var isEndOfList = false
    var isBusy = false
    
    @Published var posts: [Post] = []
    
    func fetch10Posts() async throws {
        isBusy = true
        let newPosts = try await postManager.fetchUserPosts()
        
        isEndOfList = newPosts.count < 10 ? true : false
        
        // 이부분 community 뷰모델에서는 왜 DispatchQueue 썼나요?
        DispatchQueue.main.sync {
            self.posts = newPosts
        }
        
        isBusy = false
    }
    
    // 이건 어디쓰는건지?
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
