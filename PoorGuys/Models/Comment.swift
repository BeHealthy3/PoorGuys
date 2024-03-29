//
//  Comment.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation
import LoremSwiftum

struct Comment: Identifiable, Codable, Equatable {
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.id == rhs.id
        && lhs.content == rhs.content
        && lhs.userID == rhs.userID
        && lhs.likedUserIDs == rhs.likedUserIDs
        && lhs.profileImageURL == rhs.profileImageURL
        && lhs.nickName == rhs.nickName
        && lhs.userID == rhs.userID
        && lhs.postID == rhs.postID
        && lhs.timeStamp == rhs.timeStamp
        && lhs.isDeletedComment == rhs.isDeletedComment
        && lhs.belongingCommentID == rhs.belongingCommentID
    }
    
    static func dummy() -> Comment {
        let id: String = "\(Int.random(in: 1...10))"
        let nickName: String = Lorem.word
        let profileImageURL: String? = "https://picsum.photos/200/300"
        let userID: String = "dummyUserID\(String.randomString(length: 10))"
        let postID: String = "dummyPostID\(String.randomString(length: 10))"
        let likedUserIDs: [String] = ["dummyUserID\(String.randomString(length: 10))"]
        let timeStamp: Date = Date().addingTimeInterval(-TimeInterval(Int.random(in: 0...1000)))
        let content: String = Int.random(in: 1...12).isMultiple(of: 4) ? Lorem.paragraph : Lorem.sentence
        
        return Comment(id: id, nickName: nickName, profileImageURL: profileImageURL, userID: userID, postID: postID, content: content, likedUserIDs: likedUserIDs, timeStamp: timeStamp, isDeletedComment: Int.random(in: 1...12).isMultiple(of: 7) ? true : false, belongingCommentID: Int.random(in: 1...12).isMultiple(of: 2) ? nil : "\(2)")
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
    var likedUserIDs: [String]
    var timeStamp: Date
    var isDeletedComment: Bool
    var belongingCommentID: String?
}
