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
    func fetch20Posts() async throws -> [Post]
    func fetchNext10Posts(from: Post) async throws -> [Post]
    func fetchPrevious10Posts(from: Post) async throws -> [Post]
}
