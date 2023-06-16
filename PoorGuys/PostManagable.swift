//
//  PostManagable.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import SwiftUI

protocol PostManagable {
    func uploadImage(_ image: UIImage) async throws -> URL
    func uploadNewPost(_ post: Post, with image: UIImage?) async throws
    func updatePost(_ post: Post, with image: UIImage) async throws
    mutating func fetch10Posts() async throws -> [Post]
    func fetchPost(postID: String) async throws -> Post
    
    func uploadNewComment(_ comment: Comment) throws
    func deleteComment(commentID: String) async throws
    
//    func uploadNewReply(_ reply: Reply) throws
//    func deleteReply(replyID: String) async throws
}
