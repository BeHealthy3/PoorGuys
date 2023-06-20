//
//  UIDevice+Extension.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import UIKit

extension UIDevice {
    // 디바이스에 노치가 있는지 없는지 확인
    var hasNotch: Bool {
        let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let bottom = scene?.windows.first?.safeAreaInsets.bottom ?? .zero
        return bottom > 0
    }
}
