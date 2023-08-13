//
//  ExportingSaveHistoryView.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/08/10.
//

import SwiftUI

struct ExportingSaveHistoryView<ViewModel: SaveHistoryViewModelProtocol>: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isPresenting: Bool
    
    var body: some View {
        VStack(spacing: 28) {
            VStack(spacing: 0) {
                SaveHistoryCardView(viewModel: _viewModel)
                    .frame(height: 340)
                    .background {
                        Color.white
                    }
                    
                ZStack {
                    Color.appColor(.primary500)
                    Text(DateFormatter().toKoreanIncludingYear(from: viewModel.date))
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .semibold))
                }
                .frame(width: Constants.screenWidth - 32, height: 55)
            }
            .shadow(color: .black.opacity(0.15), radius: 7.5, x: 0, y: 3)
            
            HStack {
                VStack(spacing: 19) {
                    
                    Button {
                        let screenShot = takeScreenshot()
                        guard let image = cropImage(screenShot) else { return }
                        
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    } label: {
                        RoundButton(imageName: "downloadButton")
                    }
                    
                    Text("저장")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.leading, 43)
                
                Spacer()

                VStack(spacing: 19) {
                    Button {
                        
                    } label: {
                        RoundButton(imageName: "exportButton")
                    }
                    
                    Text("공유")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                
                Spacer()
                
                VStack(spacing: 19) {
                    Button {
                        
                    } label: {
                        RoundButton(imageName: "inviteButton")
                    }
                    
                    Text("초대")
                        .foregroundColor(.appColor(.neutral900))
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.trailing, 43)
            }
            
            HStack {
                Spacer()
                Text("취소")
                    .foregroundColor(.appColor(.primary500))
                    .font(.system(size: 18, weight: .bold))
                Spacer()
            }
            .overlay(
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            self.isPresenting = false
                        }
                    }
            )
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.appColor(.primary500), lineWidth: 1)
            )
            
            Spacer()
                .onlyIf(UIDevice().hasNotch)
        }
        .padding(UIDevice().hasNotch ? .top : .vertical, 16)
        .padding(.horizontal, 16)
        .background(Color.appColor(.white))
        .cornerRadius(12)
    }
    
    private func generateImage(from view: UIView) -> UIImage? {
            let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
            return renderer.image { context in
                view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
            }
        }
    
    private func takeScreenshot() -> UIImage? {
        var image: UIImage?
        
        guard let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
                  let window = windowScene.windows.first else { return nil }
        
        let currentLayer = window.layer
        let currentScale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
        
        guard let currentContext = UIGraphicsGetCurrentContext() else { return nil }
        
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        
        return image
    }
    
    func cropImage(_ image: UIImage?) -> UIImage? {
        
//        스크린샷 잘 안찍히는게 scale factor 때문인듯. 이걸로 보정해주니까 일단 되긴 함.
        let scaleFactor = UIScreen.main.nativeScale
        let cropRect = CGRect(
            x: 16 * scaleFactor,
            y: (Constants.screenHeight - (UIDevice().hasNotch ? 653 : 629.5) + 16) * scaleFactor,
            width: (Constants.screenWidth - 32) * scaleFactor,
            height: 395 * scaleFactor
        ).integral

        guard let img = image?.cgImage, let croppedCGImage = img.cropping(to: cropRect) else { return nil }
        
        return UIImage(cgImage: croppedCGImage)
    }
    
    func cropImage(_ inputImage: UIImage, toRect cropRect: CGRect, viewWidth: CGFloat, viewHeight: CGFloat) -> UIImage? {
        let imageViewScale = max(inputImage.size.width / viewWidth,
                                 inputImage.size.height / viewHeight)
        let cropZone = CGRect(x:cropRect.origin.x * imageViewScale,
                              y:cropRect.origin.y * imageViewScale,
                              width:cropRect.size.width * imageViewScale,
                              height:cropRect.size.height * imageViewScale)
        
        guard let cutImageRef: CGImage = inputImage.cgImage?.cropping(to:cropZone) else { return nil }
        
        return UIImage(cgImage: cutImageRef)
    }
}

struct ExportingSaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        ExportingSaveHistoryView<SaveHistoryViewModel>(isPresenting: .constant(false))
            .environmentObject(SaveHistoryViewModel())
    }
}
