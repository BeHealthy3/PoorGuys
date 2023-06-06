//
//  SetNickNameView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI
import Combine

struct SetNickNameView: View {
    enum FocusedField {
        case nickName
    }
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @State private var nickName: String = ""
    @State private var isValidNickName = false
    @State private var isNickNameUnique = false
    @State private var isNickNameValid = false
    @State private var isValidatingNickName = false
    @State private var isNavigationLinkActive = false
    @State private var showNickNameNotValidated = false
    @State private var showNickNameNotUnique = false
    
    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                HStack {
                    Button {
                        loginViewModel.signOut()
                        dismiss()
                    } label: {
                        Image("xmark")
                    }
                    .padding(.leading, 16)
                    .padding(.vertical, 12)
                    Spacer()
                }
                Spacer()
                    .frame(maxHeight: 76)
                description()
                setNickName()
                    .padding(.vertical, 40)
                nextButton()
                    .padding(.top, 24)
                Spacer()
                NavigationLink(destination: SetProfileImageView(), isActive: $isNavigationLinkActive) {
                    EmptyView()
                }
                .hidden()
            }
        }
        .onAppear {
            focusedField = .nickName
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    @ViewBuilder
    func description() -> some View {
        VStack(spacing: 8) {
            Text("어푸어푸에 오신 걸 환영합니다!")
                .font(.system(size: 22, weight: .bold))
            Text("사용하실 닉네임을 알려주세요.")
                .font(.system(size: 22, weight: .bold))
        }
    }
    
    @ViewBuilder
    func setNickName() -> some View {
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
                        Text(showNickNameNotUnique ? "이미 사용 중인 닉네임입니다" : "한글, 영어, 숫자 이용하여 8글자 이내, 숫자만은 불가능")
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
        .padding(.horizontal, 16)
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
    
    @ViewBuilder
    func nextButton() -> some View {
        Button {
            /* TODO : 다음 버튼 탭 시 username 등록 */
            // 닉네임 유효할 때만
            if isValidNickName {
                // firestore에 닉네임 저장 후 저장 완료되면 다음으로 넘어가기
                loginViewModel.updateUserNickName(nickName) { isUpdateSuccessed, error in
                    if isUpdateSuccessed {
                        self.isNavigationLinkActive = true
                    } else {
                        print("Error: updating nickName failed : \(String(describing: error?.localizedDescription))")
                    }
                }
            }
        } label: {
            Text("다음")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("title.loginButtons"))
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(isValidNickName ? Color("primary_500") : Color("primary_100"))
                }
                .padding(.horizontal, 16)
        }
        .padding(.bottom, 40)
        .animation(.easeInOut, value: isValidNickName)
    }
}

struct SetNickNameView_Previews: PreviewProvider {
    static var previews: some View {
        SetNickNameView()
            .environmentObject(LoginViewModel())
    }
}
