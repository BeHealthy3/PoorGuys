//
//  Post.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation
import LoremSwiftum

struct Post: Identifiable, Equatable, Codable {
    
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }
    
    static func dummy() -> Post {
        let dummyID = "\(UUID())"
        let dummyUserId = "dummyID\(String.randomString(length: 8))"
        let nickName = "dummyNickname\(String.randomString(length: 8))"
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let likedUserIDs: [String] = ["dummyUserID\(String.randomString(length: 10))"]
        let title = Lorem.sentence
        let body = Int.random(in: 1...10).isMultiple(of: 5) ? Lorem.paragraph : Lorem.sentence
        let timeStamp = Date()
        let imageURL: [String]? = ["https://picsum.photos/200/300"]
        let isAboutMoney = Int.random(in: 1...10).isMultiple(of: 5) ? true : false
        let isWeirdPost = Int.random(in: 1...10).isMultiple(of: 5) ? true : false
    
        return Post(id: dummyID, userID: dummyUserId, nickName: nickName, profileImageURL: profileImageURL, isAboutMoney: isAboutMoney, title: title, body: body, timeStamp: timeStamp, likedUserIDs: likedUserIDs, isWeirdPost: isWeirdPost, imageURL: imageURL, comments: Comment.multipleDummies(number: 3))
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
    var likedUserIDs: [String]
    var isWeirdPost: Bool
    var imageURL: [String]?
    var comments: [Comment]
    
    enum codingKeys: String, CodingKey {
        case id, userID, nickName, profileImageURL, isAboutMoney, title, body, timeStamp, likeCount ,commentCount, isWeirdPost, imageURL, comments
    }
}
