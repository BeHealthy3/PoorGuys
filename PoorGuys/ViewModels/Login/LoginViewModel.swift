//
//  LoginViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum LoginState {
    case signedIn
    case signedOut
}

class LoginViewModel: ObservableObject {
    @Published var signInState: LoginState = .signedOut
    
    // MARK: - 로그인 / 로그아웃
    /// 구글로 로그인
    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // 구글 로그인 설정 객체 생성
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // root 뷰컨 찾기
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
        
        // 로그인 플로우 시작
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [unowned self] result, error in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print(error?.localizedDescription as Any)
                return
            }
            
            // 사용자 인증 정보 생성
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            // 생성한 인증 정보 사용해 로그인
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.signInState = .signedIn
                    print("유저 로그인 완료 / uid : \(result?.user.uid ?? "")")
                }
            }
        }
    }
    
    /// 유저 로그아웃 - 모든 인증방식에 적용
    func signOut() {
        // GIDSignIn.sharedInstance()?.currentUser 에 nil 할당
        GIDSignIn.sharedInstance.signOut()
        
        // 파이어베이스 Auth 로그아웃
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        
        self.signInState = .signedOut
        print("유저 로그아웃 완료")
    }
    
    func authDidChangeListener() {
        Auth.auth().addStateDidChangeListener({ auth, user in
            if let user = user {
                print("In authDidChangeListener... 유저 로그인 완료 : \(user.uid)")
            } else {
                print("In authDidChangeListener... 유저 로그인되지 않음")
            }
        })
    }
}
