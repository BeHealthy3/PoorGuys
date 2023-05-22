//
//  Reply.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/20.
//

import Foundation

struct Reply {
    var id: String
    var profileImageURL: String?
    var userID: String
    var postID: String
    var belongingCommentID: String
    var targetUserID: String
    var content: String
    var likeCount: Int
    var timeStamp: Date
}
