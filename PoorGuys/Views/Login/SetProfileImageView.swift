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
    
    @State private var pickedPhoto: UIImage = UIImage(named: "user.default")!
    @State private var isNavigationLinkActive = false
    @State private var isPhotoPickerPresented = false
    @State private var isPhotoPickedByUser = false
    
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
                .scaledToFill()
                .frame(width: 170, height: 170)
                .clipShape(Circle())
                .padding(.top, 50)
                .overlay {
                    Image("icon.camera")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .offset(x: 65, y: 80)
                        .shadow(color: Color.black.opacity(0.1), radius: 10)
                        
                }
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
            PhotoPicker(pickerResult: $pickedPhoto, isPresented: $isPhotoPickerPresented, isPhotoPickedByUser: $isPhotoPickedByUser)
        }
        .onAppear {
            pickedPhoto = UIImage(named: "user.default")!
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
            loginViewModel.updateUserProfileImage(pickedPhoto) { isSuccess, error in
                if isSuccess {
                    self.isNavigationLinkActive = true
                } else {
                    print("error on updating user profile image : \(String(describing: error?.localizedDescription))")
                }
            }
        } label: {
            Text("완료")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isPhotoPickedByUser ? Color("primary_500") : Color("primary_100"))
                }
                .padding(.horizontal, 16)
                .animation(.easeOut, value: isPhotoPickedByUser)
        }
        .disabled(!isPhotoPickedByUser)
    }
}

struct SetProfileImageView_Previews: PreviewProvider {
    static var previews: some View {
        SetProfileImageView()
            .environmentObject(LoginViewModel())
    }
}
