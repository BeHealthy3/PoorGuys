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

enum SignInState {
    case signedIn
    case signedOut
}

final class LoginViewModel: ObservableObject {
    @Published var signInState: SignInState = .signedOut // Auth 로그인 상태
    @Published var isUserInFirestore: Bool = false // 유저가 firestore에 저장되어있는지
    @Published var didSetNickName: Bool = false // firestore에 저장되어있는 유저 데이터에 닉네임 저장되어있는지
    @Published var signUpCompleted: Bool = false
    
    @Published var nickName: String = ""
    @Published var isValidatingNickName = false
    
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
                    if let result = result {
                        print("유저 auth 로그인 완료 / uid : \(result.user.uid)")
                        
                        // auth 로그인된 유저 정보가 firestore에도 있는지 확인
                        self.checkIfUserDataIsInFirestore(of: result.user.uid)
                    } else {
                        print("!ERROR : Auth result nil - 확인 필요")
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
        
        isUserInFirestore = false
        didSetNickName = false
        signUpCompleted = false
        
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
    
    /// Firestore에 유저 정보 등록되어있는지 확인
    /// - Parameter result: Auth.auth().signIn(with:) 함수의 completion result
    func checkIfUserDataIsInFirestore(of uid: String) {
        // 구글 인증은 로그인과 회원가입 구분이 없기 때문에
        // firestore에 이미 있는 회원인지 확인 후, 없으면 firestore DB에 등록
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(uid)
        
        /* TODO : 여기서 앱이 종료되어서 firestore에 유저 저장이 안된다면..?
         매번 앱 실행마다 확인 필요 */
        
        docRef.getDocument { document, error in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                print("해당하는 유저 firestore에 있음 : \(dataDescription)")
                self.isUserInFirestore = true
                if let property = document.get("nickName") as? String {
                    if property.isEmpty {
                        print("해당 유저 닉네임 설정되지 않음")
                        self.didSetNickName = false
                    }
                    else {
                        self.didSetNickName = true
                        self.signUpCompleted = true
                    }
                }
            } else {
                print("해당하는 유저 없음")
                // MARK: - 유저 firestore 추가
                db.collection("users").document(uid).setData([
                    "nickName" : "",
                    "profileImageURL" : "", // TODO : 기본 프로필 이미지 URL 넣기
                ]) { error in
                    if let error = error {
                        /* TODO : 유저 등록 중 오류가 났을 때 앱에서 어떤 동작을 취해주어야 할까? */
                        print("유저 등록 중 오류 : \(error)")
                        self.isUserInFirestore = false
                    } else {
                        print("새로운 유저 firestore에 등록 완료")
                        self.isUserInFirestore = true
                    }
                }
            }
        }
    }
    
    /// 닉네임 유효성을 확인합니다
    /// - Parameter nickName: 유효성을 확인할 닉네임
    /// - Returns: 닉네임 유효성 확인 결과
    func isValidNickName(_ nickName: String) async throws -> Bool {
        // 닉네임 유효성 체크
        var isNickNameValid = false
        var regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9가-힣]{2,14}$")
        isNickNameValid = regex.firstMatch(in: nickName, range: NSRange(location: 0, length: nickName.count)) != nil
        // 닉네임 숫자만인지 체크
        regex = try! NSRegularExpression(pattern: "^[0-9]+$")
        isNickNameValid = !(regex.firstMatch(in: nickName, range: NSRange(location: 0, length: nickName.count)) != nil)
        if isNickNameValid {
            let isUnique = try await isNickNameUnique(nickName)
            // 닉네임 중복 체크
            if try await isUnique.value {
                DispatchQueue.main.async {
                    self.signUpCompleted = true
                }
            } else {
                DispatchQueue.main.async {
                    self.signUpCompleted = false
                }
            }
        } else {
            return false
        }
        return signUpCompleted
    }
    
    /// 닉네임 중복을 확인합니다
    /// - Parameter nickName: 중복을 확인할 닉네임
    /// - Returns: 닉네임 중복 확인 결과
    private func isNickNameUnique(_ nickName: String) async throws -> Task<Bool, Error> {
        Task {
            let db = Firestore.firestore()
            let docRef = db.collection("users").whereField("nickName", isEqualTo: nickName)
            var isUnique = false
            do {
                let snapshot = try await docRef.getDocuments()
                isUnique = snapshot.isEmpty
            } catch {
                print("닉네임 중복 확인 중 오류 : \(error)")
                throw error
            }
            return isUnique
        }
    }
}
