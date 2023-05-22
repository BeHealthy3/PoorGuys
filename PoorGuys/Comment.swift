//
//  Comment.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation

struct Comment {
    var id: String
    var nickName: String
    var profileImageURL: String?
    var userID: String
    var postID: String
    var content: String
    var isFirstLevelComment: Bool
    var likeCount: Int
    var timeStamp: Date
    var reply: [Reply]?
}
