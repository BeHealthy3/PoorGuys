//
//  Comment.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation
import LoremSwiftum

struct Comment: Identifiable {
    
    static func dummy() -> Comment {
        let id: String = "\(UUID())"
        let nickName: String = Lorem.word
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let userID: String = "dummyUserID\(String.randomString(length: 10))"
        let postID: String = "dummyPostID\(String.randomString(length: 10))"
        let likeCount: Int = Int.random(in: 0...20)
        let timeStamp: Date = Date()
        let content: String = likeCount.isMultiple(of: 4) ? Lorem.paragraph : Lorem.sentence
        
        return Comment(id: id, nickName: nickName, profileImageURL: profileImageURL, userID: userID, postID: postID, content: content, likeCount: likeCount, timeStamp: timeStamp, isDeletedComment: likeCount.isMultiple(of: 7) ? true : false, replies: likeCount.isMultiple(of: 3) ? Reply.multipleDummies(number: 10) : nil)
    }
    
    static func multipleDummies(number: Int) -> [Comment] {
        var comments = [Comment]()
        
        for _ in (1...number) {
            comments.append(Comment.dummy())
        }
        
        return comments
    }
    
    var id: String
    var nickName: String
    var profileImageURL: String?
    var userID: String
    var postID: String
    var content: String
    var likeCount: Int
    var timeStamp: Date
    var isDeletedComment: Bool
    var replies: [Reply]?
}
