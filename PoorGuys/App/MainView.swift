//
//  ContentView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    @EnvironmentObject var logInViewModel: LoginViewModel
    
    @State private var isShowingLaunchScreen = true
    
    var body: some View {
        Group {
            // 런치스크린 보이기
            if isShowingLaunchScreen {
                LaunchScreen()
                    .task {
                        // auth 상태 변경을 감지하는 리스너 추가
                        logInViewModel.authDidChangeListener()
                        // 유저 로그인 완료하였는지 확인
                        logInViewModel.isSignUpAndSignInCompleted { isCompleted, error in
                            if let error = error {
                                print("Error while signUp completion check : \(error)")
                                isShowingLaunchScreen = false
                            } else {
                                if isCompleted {
                                    isShowingLaunchScreen = false
                                    logInViewModel.signInState = .signedIn
                                } else {
                                    isShowingLaunchScreen = false
                                    logInViewModel.signInState = .signedOut
                                }
                            }
                        }
                    }
            } else {
                // 로그아웃 되어있거나, 닉네임 설정되어 있지 않으면 로그인 뷰 보이기
                if logInViewModel.signInState == .signedOut || !logInViewModel.didSetNickName {
                    LoginView()
                } else {
                    MyPageView()
                }
            }
        }
        .preferredColorScheme(.light)   // 기기 다크모드여도 앱은 라이트모드 적용
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(LoginViewModel())
    }
}
