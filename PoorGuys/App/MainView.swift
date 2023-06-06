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
                // 유저 로그인 및 닉네임 설정 완료했다면 메인 페이지 보이기
                MyPageView() // 임시로 mypage 보이기
            }
        }
        .onAppear {
            // 유저가 로그인했으면 signInState 변경
            if Auth.auth().currentUser?.uid != nil {
                logInViewModel.signInState = .signedIn
                
                // firestore에 유저 데이터 저장되어있는지 확인
                logInViewModel.checkIfUserDataIsInFirestore(of: Auth.auth().currentUser!.uid)
            }
            
            // auth 상태 변경을 감지하는 리스너 추가
            logInViewModel.authDidChangeListener()
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
