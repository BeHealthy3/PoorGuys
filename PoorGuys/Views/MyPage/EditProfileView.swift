//
//  EditProfileView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/08.
//

import SwiftUI
import Combine

struct EditProfileView: View {
    enum FocusedField {
        case nickName
    }

    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var currentUser: User
    
    @State private var pickedPhoto: UIImage = UIImage(named: "user.default")!
    @State private var isPhotoPickerPresented = false
    @State private var nickName: String = ""
    @State private var isValidNickName = false
    @State private var isNickNameUnique = false
    @State private var isNickNameValid = false
    @State private var isValidatingNickName = false
    @State private var showNickNameNotValidated = false
    @State private var showNickNameNotUnique = false
    @State private var isPresentingConfirmationDialog = false
    
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            navigationHeader()
            editUserProfileImage()
                .padding(.bottom, 40)
            editUserNickName()
                .padding(.horizontal, 32)
            Spacer()
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            PhotoPicker(pickerResult: $pickedPhoto, isPresented: $isPhotoPickerPresented, isPhotoPickedByUser: .constant(false))
        }
        .confirmationDialog("프로필 사진 설정", isPresented: $isPresentingConfirmationDialog, actions: {
            Button("앨범에서 사진 선택") { isPhotoPickerPresented = true }
            Button("프로필 사진 삭제", role: .destructive) { pickedPhoto = UIImage(named: "user.default")! }
        }, message: {
            Text("프로필 사진 설정")
        })
        .onTapGesture {
            focusedField = nil
        }
        .onAppear {
            self.pickedPhoto = (User.currentUser?.profileImage)!
            self.nickName = User.currentUser!.nickName
        }
        
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
    }
    
    @ViewBuilder
    func navigationHeader() -> some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image("arrow.left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 16)
                }
                Spacer()
                Button {
                   /* TODO : 프로필 편집 완료*/
                    if isValidNickName {
                        // firestore에 닉네임 저장 후 저장 완료되면 다음으로 넘어가기
                        loginViewModel.updateUserNickName(nickName) { isUpdateSuccessed, error in
                            if isUpdateSuccessed {
                                loginViewModel.updateUserProfileImage(pickedPhoto) { isUpdateCompleted, error in
                                    if isUpdateCompleted {
                                        currentUser.nickName = nickName
                                        currentUser.profileImage = pickedPhoto
                                        dismiss()
                                    } else {
                                        print("Error: upating Profile Image failed : \(String(describing: error?.localizedDescription))")
                                    }
                                }
                            } else {
                                print("Error: updating nickName failed : \(String(describing: error?.localizedDescription))")
                            }
                        }
                    }
                } label: {
                    Text("완료")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("white"))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(isValidNickName ? Color("primary_500") : Color("primary_100"))
                        }
                }
                .disabled(!isValidNickName)
                .padding(.trailing, 16)
            }
            Text("프로필 편집")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .padding(.vertical, 12)
       }
    }
    
    @ViewBuilder
    func editUserProfileImage() -> some View {
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
                isPresentingConfirmationDialog = true
            }
    }
    
    @ViewBuilder
    func editUserNickName() -> some View {
        VStack {
            TextField("", text: $nickName,
                      prompt: Text("닉네임을 입력해 주세요")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color("neutral_500")))
            .focused($focusedField, equals: .nickName)
            .font(.system(size: 16, weight: .semibold))
            .padding(.vertical, 16)
            .padding(.horizontal, 16)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(showNickNameNotValidated || showNickNameNotUnique ? Color("lightred") : Color("neutral_050"))
                    if focusedField == .nickName {
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(showNickNameNotValidated || showNickNameNotUnique ? Color("red") : Color("primary_500"), lineWidth: 1)
                            .animation(.easeInOut(duration: 0.5) , value: showNickNameNotValidated || showNickNameNotUnique)
                    }
                    HStack {
                        Spacer()
                        if isValidatingNickName {
                            ProgressView()
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
            .onChange(of: nickName, perform: { newValue in
                // 입력 중이면 isValidate false
                isValidNickName = false
            })
            .onReceive(Just(nickName)) { _ in
                // 최대 닉네임 글자 수 까지만 입력 가능
                if nickName.count > Constants.maxNickNameLength {
                    nickName = String(nickName.prefix(Constants.maxNickNameLength))
                }
            }
            .onDebouncedChange(of: $nickName, debounceFor: 1) { nickName in
                // 사용자 입력 1초 후 닉네임 유효성 검증
                Task {
                    isValidatingNickName = true
                    isNickNameValid = loginViewModel.isNickNameValid(nickName)
                    if isNickNameValid {
                        isNickNameUnique = try await loginViewModel.isNickNameUnique(nickName).value
                        if isNickNameUnique {
                            isValidNickName = true
                        }
                    }
                    try await Task.sleep(nanoseconds: 100_000_000)
                    isValidatingNickName = false
                }
            }
            HStack {
                if isValidNickName {
                    Text("사용 가능한 닉네임입니다")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(Color("neutral_600"))
                        .padding(.leading, 16)
                } else {
                    if showNickNameNotValidated || showNickNameNotUnique {
                        Text(showNickNameNotUnique && !showNickNameNotValidated ? "이미 사용 중인 닉네임입니다" : "한글, 영어, 숫자 이용하여 8글자 이내, 숫자만은 불가능")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(Color("red"))
                            .padding(.leading, 16)
                    } else {
                        Text(showNickNameNotUnique ? "이미 사용 중인 닉네임입니다" : "한글, 영어, 숫자 이용하여 8글자 이내, 숫자만은 불가능")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(Color("neutral_600"))
                            .padding(.leading, 16)
                    }
                }
                Spacer()
            }
            .animation(.easeInOut(duration: 0.1) , value: isValidNickName || showNickNameNotValidated || showNickNameNotUnique)
        }
        .onChange(of: isValidatingNickName) { isValidating in
            if !isValidating {
                if !isNickNameValid {
                    showNickNameNotValidated = true
                } else {
                    showNickNameNotValidated = false
                    if !isNickNameUnique {
                        showNickNameNotUnique = true
                    } else {
                        showNickNameNotUnique = false
                    }
                }
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(currentUser: .constant(User(uid: "", nickName: "", authenticationMethod: .google)))
    }
}
