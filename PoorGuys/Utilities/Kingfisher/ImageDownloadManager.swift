//
//  ImageDownloadManager.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/06/04.
//

import UIKit
import Kingfisher

struct ImageDownloadManager {    
    func downloadImageAndSaveAsUIImage(url: URL) async throws -> UIImage {
        return try await withCheckedThrowingContinuation { continuation in
            let downloader = ImageDownloader.default
            let options: KingfisherOptionsInfo = [.onFailureImage(UIImage(systemName: "photo"))]
            
            downloader.downloadImage(with: url, options: options) { result in
                switch result {
                case .success(let value):
                    continuation.resume(returning: value.image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
