//
//  UserModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import UIKit

enum AuthenticationMethod {
    case google
    case apple
}

struct User {
    static var currentUser: User?
    
    var uid: String
    var nickName: String
    var profileImageURL: String?
    var profileImage: UIImage?
    var authenticationMethod: AuthenticationMethod
}
