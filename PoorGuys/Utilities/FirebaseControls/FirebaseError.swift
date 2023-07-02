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
    
    var nsError: NSError {
        return NSError(domain: "FirebaseError", code: 0, userInfo: [NSLocalizedDescriptionKey: localizedDescription])
    }
        
    var localizedDescription: String {
        switch self {
        case .documentNotFound:
            return "Document not found."
        case .imageNotConvertable:
            return "Image cannot be converted."
        case .userNotFound:
            return "User not found."
        case .updateFailed:
            return "Update failed."
        case .encodingError:
            return "Encoding error."
        }
    }
}
