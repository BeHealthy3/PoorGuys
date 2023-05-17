//
//  UserModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import Foundation

enum AuthenticationMethod {
    case google
    case apple
}

struct User {
    var uid: String
    var nickName: String
    var profileImageURL: String?
    var authenticationMethod: AuthenticationMethod
}
