//
//  Reply.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation
import LoremSwiftum

struct Reply: Identifiable {
    
    static func dummy() -> Reply {
        let id: String = "\(UUID())"
        let nickName: String = Lorem.word
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let userID: String = "dummyUserID\(String.randomString(length: 10))"
        let postID: String = "dummyPostID\(String.randomString(length: 10))"
        let belongingCommentID: String = "dummyID\(String.randomString(length: 10))"
        let targetUserID: String = "dummyID\(String.randomString(length: 10))"
        let likeCount: Int = Int.random(in: 0...20)
        let content: String = likeCount.isMultiple(of: 7) ? Lorem.paragraph : Lorem.sentence
        
        let timeStamp: Date = Date()
        
        return Reply(id: id, nickName: nickName, profileImageURL: profileImageURL, userID: userID, postID: postID, belongingCommentID: belongingCommentID, targetUserID: targetUserID, content: content, likeCount: likeCount, isDeletedReply: likeCount.isMultiple(of: 7) ? true : false, timeStamp: timeStamp)
    }
    
    static func multipleDummies(number: Int) -> [Reply] {
        var replies = [Reply]()
        
        for _ in (1...number) {
            replies.append(Reply.dummy())
        }
        
        return replies
    }
    var id: String
    var nickName: String
    var profileImageURL: String?
    var userID: String
    var postID: String
    var belongingCommentID: String
    var targetUserID: String
    var content: String
    var likeCount: Int
    var isDeletedReply: Bool
    var timeStamp: Date
}
