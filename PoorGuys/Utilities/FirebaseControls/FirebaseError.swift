//
//  FirebaseError.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/06/14.
//

import Foundation

enum FirebaseError: Error {
    case documentNotFound
    case imageNotConvertable
    case userNotFound
    case updateFailed
    case encodingError
}
