//
//  Publishers+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/24.
//

import SwiftUI
import Combine

extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .map { notification -> CGFloat in
                let keyboardFrame = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                return keyboardFrame.height
            }
        
        let willHide = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ -> CGFloat in
                0
            }
        
        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
