//
//  PhotoPicker.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/01.
//

import SwiftUI
import UIKit
import PhotosUI

/// 프로필 사진 선택을 위한 포토 피커
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var pickerResult: UIImage
    @Binding var isPresented: Bool
    
    func makeUIViewController(context: Context) -> some UIViewController {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images // live photo도 넣어야 할까?
        
        let photoPickerViewController = PHPickerViewController(configuration: configuration)
        photoPickerViewController.delegate = context.coordinator
        return photoPickerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: PHPickerViewControllerDelegate {
        private let parent: PhotoPicker
        
        init(parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            if !results.isEmpty {
                // 선택한 아이템 언팩
                if results[0].itemProvider.canLoadObject(ofClass: UIImage.self) {
                    results[0].itemProvider.loadObject(ofClass: UIImage.self) { [weak self] newImage, error in
                        if let error = error {
                            print("이미지 로드 실패 \(error.localizedDescription)")
                        } else if let image = newImage as? UIImage {
                            self?.parent.pickerResult = image
                        }
                    }
                } else {
                    print("에셋 로드 불가")
                }
            }
            // 모달 뷰 닫기
            parent.isPresented = false
        }
    }
}
