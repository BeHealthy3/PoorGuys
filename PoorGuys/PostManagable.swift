//
//  PostManagable.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation

protocol PostManagable {
    func uploadNewPost(_ post: Post) async throws
    func updatePost(_ post: Post) async throws
    mutating func fetch10Posts() async throws -> [Post]
    func fetchPost(postID: String) async throws -> Post
    
    func uploadNewComment(_ comment: Comment) throws
    func deleteComment(commentID: String) async throws
    
//    func uploadNewReply(_ reply: Reply) throws
//    func deleteReply(replyID: String) async throws
}
