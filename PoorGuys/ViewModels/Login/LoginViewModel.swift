//
//  LoginViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

enum LoginState {
    case signedIn
    case signedOut
}

class LoginViewModel: ObservableObject {
    @Published var signInState: LoginState = .signedOut
    
    // MARK: - 로그인 / 로그아웃
    /// 구글로 로그인 및 firestore 유저 정보 등록
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
                    
                    // 구글 인증은 로그인과 회원가입 구분이 없기 때문에
                    // firestore에 이미 있는 회원인지 확인 후, 없으면 firestore DB에 등록
                    let db = Firestore.firestore()
                    let docRef = db.collection("users").document((result?.user.uid)!)
                    
                    docRef.getDocument { document, error in
                        if let document = document, document.exists {
                            let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                            print("해당하는 유저 있음 : \(dataDescription)")
                        } else {
                            print("해당하는 유저 없음")
                            // 유저 추가
                            db.collection("users").document((result?.user.uid)!).setData([
                                // 이 두가지만 사용하면 사실 firestore에 등록하지 않아도 firebase authentication에서 모두 처리 가능
                                // 그러나 확장성 생각해서 등록하면 좋을 듯..
                                "nickName" : "",
                                "profileImageURL" : "",
                            ]) { error in
                                if let error = error {
                                    print("유저 등록 중 오류 : \(error)")
                                } else {
                                    print("새로운 유저 firestore에 등록 완료")
                                }
                            }
                        }
                    }
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
    
    /// 유저 로그인 / 로그아웃 시 호출되는 리스너 생성
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
