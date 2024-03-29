//
//  PostManagable.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import SwiftUI

protocol PostManagable {
    func uploadNewPost(_ post: Post, with image: UIImage?) async throws
    func updatePost(_ post: Post, with image: UIImage?) async throws
    mutating func fetch10Posts() async throws -> [Post]
    func fetchPost(postID: String) async throws -> Post
    func removePost(postID: String) async throws
    func fetchUserPosts() async throws -> [Post]
    func fetchUserCommentedPosts() async throws -> [Post]
    func fetchUserLikedPosts() async throws -> [Post]
    mutating func removeLocalPosts()
    func addNewComment(with newComment: Comment, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws
    func removeComment(id: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws
    func toggleCommentLike(commentID: ID, postID: ID, handler: @escaping (Result<Bool, Error>) -> Void) throws
//    func deleteComment(commentID: String) async throws
    
//    func uploadNewReply(_ reply: Reply) throws
//    func deleteReply(replyID: String) async throws
}
