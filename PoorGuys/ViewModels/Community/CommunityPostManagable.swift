//
//  CommunityPostManagable.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/26.
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
