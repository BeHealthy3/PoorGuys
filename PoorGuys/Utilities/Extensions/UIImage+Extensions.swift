//
//  UIImage+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/22.
//

import SwiftUI

extension UIImage {
    func croppedToSquare() -> UIImage {
        let contextImage: UIImage = UIImage(cgImage: self.cgImage!)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var width: CGFloat = contextSize.width
        var height: CGFloat = contextSize.height

        // 이미지의 가로와 세로 중 작은 길이를 기준으로 정사각형을 만듭니다.
        if contextSize.width > contextSize.height {
            posX = (contextSize.width - contextSize.height) / 2
            width = contextSize.height
        } else {
            posY = (contextSize.height - contextSize.width) / 2
            height = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        let croppedImage: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)
        return croppedImage
    }
}
