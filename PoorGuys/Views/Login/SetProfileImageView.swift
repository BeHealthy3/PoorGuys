//
//  SetProfileImageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct SetProfileImageView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var pickedPhoto: UIImage = UIImage()
    @State private var isNavigationLinkActive = false
    @State private var isPhotoPickerPresented = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    self.presentationMode.wrappedValue.dismiss()
                } label: {
                    Image("arrow.left")
                }
                .padding(.leading, 16)
                .padding(.vertical, 12)
                Spacer()
            }
            Spacer()
                .frame(height: 76)
            VStack(spacing: 8) {
                Text("000님이 거지방에서 사용하실")
                    .font(.system(size: 22, weight: .bold))
                Text("프로필 사진을 등록해 주세요.")
                    .font(.system(size: 22, weight: .bold))
            }
            .padding(.horizontal, 40)
            Image(uiImage: pickedPhoto)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .frame(width: 200, height: 200)
                .onTapGesture {
                    isPhotoPickerPresented = true
                }
            Spacer()
            VStack(spacing: 8) {
                skipButton()
                completeButton()
            }
            .padding(.bottom, 40)
            NavigationLink(destination: SignUpCompletedView(), isActive: $isNavigationLinkActive) {
                EmptyView()
            }
            .hidden()
            .navigationBarBackButtonHidden(true)
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            PhotoPicker(pickerResult: $pickedPhoto, isPresented: $isPhotoPickerPresented)
        }
    }
    
    @ViewBuilder
    func skipButton() -> some View {
        Button {
            /* TODO : 프로필 사진 업로드 건너뛰기 */
            self.isNavigationLinkActive = true
        } label: {
            Text("건너뛰기")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .overlay {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.blue, lineWidth: 1)
                }
                .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func completeButton() -> some View {
        Button {
            /* TODO : 첫 로그인 완료 */
            loginViewModel.updateUserProfileImage(pickedPhoto)
            self.isNavigationLinkActive = true
        } label: {
            Text("완료")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
        }
    }
}

struct SetProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfileImageView()
            .environmentObject(LoginViewModel())
    }
}
