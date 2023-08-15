//
//  Constants.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/25.
//

import UIKit

enum Constants {
    static let maxNickNameLength = 14
    static let screenHeight = UIScreen.main.bounds.height
    static let screenWidth = UIScreen.main.bounds.width
    static let bottomNotchHeight: CGFloat? = {
        guard let keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else {
            return nil
        }
        return keyWindow.safeAreaInsets.bottom
    }()
    static let topStatusBarHeight: CGFloat? = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        
        return windowScene.statusBarManager?.statusBarFrame.height
    }()
}
