//
//  KeyboardHandler.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/11.
//

import SwiftUI
import Combine

class KeyboardHandler: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
    }
}
