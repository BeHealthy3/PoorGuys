//
//  Post.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation

struct Post: Identifiable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    static func dummyPost() -> Post {
        let dummyID = "\(UUID())"
        let dummyUserId = "dummyUserId"
        let nickName = "dummyNickname\(Int.random(in: (10...90)))"
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let title = "dummyTitle\(Int.random(in: (10...90)))"
        let body = "dummyBody\(Int.random(in: (10...90)))"
        let timeStamp = Date()
        let likeCount = Int.random(in: 0...10)
        let commentCount = Int.random(in: 0...10)
        let imageURL: [String]? = ["https://picsum.photos/200/300"]
        let comments: [Comment]? = nil
    
        return Post(id: dummyID, userID: dummyUserId, nickName: nickName, profileImageURL: profileImageURL, isAboutMoney: likeCount.isMultiple(of: 3) ? true : false, title: title, body: body, timeStamp: timeStamp, likeCount: likeCount, commentCount: commentCount, isWeirdPost: likeCount.isMultiple(of: 7) ? true : false, imageURL: imageURL, comments: comments)
    }
    
    var id: String
    var userID: String
    var nickName: String
    var profileImageURL: String?
    var isAboutMoney: Bool
    var title: String
    var body: String
    var timeStamp: Date
    var likeCount: Int
    var commentCount: Int
    var isWeirdPost: Bool
    var imageURL: [String]?
    var comments: [Comment]?
}
