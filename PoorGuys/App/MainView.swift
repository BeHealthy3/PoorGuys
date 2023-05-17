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
    
    var body: some View {
        Group {
            // 유저가 로그인되어 있지 않으면 로그인 뷰 보이기
            if logInViewModel.signInState == .signedOut {
                LoginView()
                // 유저가 로그인되어 있으면?
                /* TODO : 커뮤니티 화면을 보일 것인가, 아낌내역 화면을 보일 것인가? */
            } else {
                // 임시로 마이페이지 보이도록 하기
                MyPageView()
            }
        }
        .onAppear {
            // 유저가 로그인했으면 signInState 변경
            if Auth.auth().currentUser?.uid != nil {
                logInViewModel.signInState = .signedIn
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
