//
//  Post.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation
import LoremSwiftum

struct Post: Identifiable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    static func dummy() -> Post {
        let dummyID = "\(UUID())"
        let dummyUserId = "dummyID\(String.randomString(length: 8))"
        let nickName = "dummyNickname\(String.randomString(length: 8))"
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let likeCount = Int.random(in: 0...10)
        let commentCount = Int.random(in: 0...10)
        let title = Lorem.sentence
        let body = likeCount.isMultiple(of: 5) ? Lorem.paragraph : Lorem.sentence
        let timeStamp = Date()
        let imageURL: [String]? = ["https://picsum.photos/200/300"]
        let isAboutMoney = likeCount.isMultiple(of: 3) ? true : false
        let isWeirdPost = likeCount.isMultiple(of: 7) ? true : false
    
        return Post(id: dummyID, userID: dummyUserId, nickName: nickName, profileImageURL: profileImageURL, isAboutMoney: isAboutMoney, title: title, body: body, timeStamp: timeStamp, likeCount: likeCount, commentCount: commentCount, isWeirdPost: isWeirdPost, imageURL: imageURL, comments: likeCount.isMultiple(of: 1) ? Comment.multipleDummies(number: 10) : nil)
    }
    
    static func multipleDummies(number: Int) -> [Post] {
        var posts = [Post]()
        
        for _ in (1...number) {
            posts.append(Post.dummy())
        }
        
        return posts
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
