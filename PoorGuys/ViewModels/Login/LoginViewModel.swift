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
import FirebaseStorage
import GoogleSignIn

enum SignInState {
    case signedIn
    case signedOut
}

enum LoginError: Error {
    case noCurrentUser
    case noNickName
    case authResultNil
}

final class LoginViewModel: ObservableObject {
    @Published var signInState: SignInState = .signedOut // Auth 로그인 상태
    @Published var isUserInFirestore: Bool = false // 유저가 firestore에 저장되어있는지
    @Published var didSetNickName: Bool = false // firestore에 저장되어있는 유저 데이터에 닉네임 저장되어있는지
    @Published var nickName: String = ""
    @Published var isValidatingNickName = false
    
    // MARK: - 로그인
    /// 구글로 로그인 및 firestore 유저 정보 등록
    func signInWithGoogle(completion: @escaping (_ isSignInSuccess: Bool, Error?) -> Void) {
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
                completion(false, error)
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                print(error?.localizedDescription as Any)
                completion(false, error)
                return
            }
            
            // 사용자 인증 정보 생성
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            // 생성한 인증 정보 사용해 로그인
            Auth.auth().signIn(with: credential) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, error)
                } else {
                    self.signInState = .signedIn
                    if let result = result {
                        print("유저 auth 로그인 완료 / uid : \(result.user.uid)")
                        
                        // auth 로그인된 유저 정보가 firestore에도 있는지 확인
                        self.isUserDataStoredInFirestore(of: result.user.uid) { isStored, error in
                            completion(isStored, error)
                        }
                    } else {
                        print("!ERROR : Auth result nil - 확인 필요")
                        completion(false, LoginError.authResultNil)
                    }
                }
            }
        }
    }
    
    /// Firestore에 유저 정보 등록되어있는지 확인
    /// - Parameter result: Auth.auth().signIn(with:) 함수의 completion result
    func isUserDataStoredInFirestore(of uid: String, completion: @escaping (Bool, Error?) -> Void) {
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
                        completion(false, error)
                    }
                    else {
                        self.setCurrentUser { isUser, error in
                            if let error = error {
                                print("Error while setting current user : \(error)")
                                completion(false, nil)
                            } else {
                                DispatchQueue.main.async {
                                    self.didSetNickName = true
                                }
                                completion(true, nil)
                            }
                        }
                    }
                }
            } else {
                print("해당하는 유저 없음")
                completion(false, nil)
                // MARK: - 유저 firestore 추가
                db.collection("users").document(uid).setData([
                    "nickName" : "",
                    "profileImageURL" : "" // TODO : 기본 프로필 이미지 URL 넣기
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
    
    /// 회원가입 및 로그인 완료 여부 판단
    /// - Returns: 회원가입 및 로그인 완료했는지
    func isSignUpAndSignInCompleted(completion: @escaping (Bool, Error?) -> Void) {
        // 현재 로그인된 유저가 있나요?
        if let uid = Auth.auth().currentUser?.uid {
            signInState = .signedIn
            
            // 로그인된 유저가 있다면, 해당 유저의 닉네임이 설정되어있나요?
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            
            docRef.getDocument { document, error in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("해당하는 유저 firestore에 있음 : \(dataDescription)")
                    self.isUserInFirestore = true
                    if let property = document.get("nickName") as? String {
                        if property.isEmpty {
                            print("해당 유저 닉네임 설정되지 않음")
                            self.didSetNickName = false
                            completion(false, LoginError.noNickName)
                        }
                        else {
                            self.setCurrentUser { isUser, error in
                                if let error = error {
                                    print("Error while setting current user : \(error)")
                                    completion(false, nil)
                                } else {
                                    DispatchQueue.main.async {
                                        self.didSetNickName = true
                                    }
                                    completion(true, nil)
                                }
                            }
                        }
                    }
                } else {
                    print("해당하는 유저 없음")
                    completion(false, error)
                }
            }
            
        } else {
            completion(false, LoginError.noCurrentUser)
        }
    }
    
    /// currentUser 모델 값 채워넣기
    func setCurrentUser(completion: @escaping (Bool, Error?) -> Void) {
        var nickName: String?
        var profileImageURL: String?
        if let uid = Auth.auth().currentUser?.uid {
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)
            
            docRef.getDocument { document, error in
                if let document = document, document.exists {
                    if let _nickName = document.get("nickName") as? String {
                        nickName = _nickName
                    } else {
                        completion(false, LoginError.noNickName)
                    }
                    
                    if let _profileImageURL = document.get("profileImageURL") as? String {
                        profileImageURL = _profileImageURL
                        URLSession.shared.dataTask(with: URL(string: profileImageURL!)!) { data, response, error in
                            guard let data = data, error == nil else {
                                completion(false, error)
                                return
                            }
                            let profileImage = UIImage(data: data)
                            User.currentUser = User(uid: uid, nickName: nickName ?? "", profileImageURL: profileImageURL, profileImage: profileImage, authenticationMethod: .google)
                            self.setCurrentUserProvider()
                            print("currentUser 생성 완료")
                            completion(true, nil)
                        }.resume()
                    } else {
                        completion(true, nil)
                    }
                } else {
                    print("Error while getting from document : \(String(describing: error))")
                    completion(false, error)
                }
            }
            
        }
    }
    
    func setCurrentUserProvider() {
        if let currentUser = Auth.auth().currentUser {
            for userInfo in currentUser.providerData {
                let providerID = userInfo.providerID
                print("providerID : \(providerID)")
                
                if providerID == GoogleAuthProviderID {
                    User.currentUser?.authenticationMethod = .google
                    print("Provider : google")
                } else if providerID == "apple.com" {
                    User.currentUser?.authenticationMethod = .apple
                    print("Provider : apple")
                } else {
                    print("ERROR : 사용자가 등록되지 않은 인증 방법으로 로그인하였습니다.")
                }
            }
        }
    }
    
    // MARK: - 로그아웃
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
        User.currentUser = nil
        
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
    
    /// Updates the user's nickname in the database.
    func updateUserNickName(_ nickName: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).updateData([
                "nickName" : nickName
            ]) { error in
                if let error = error {
                    print("Error updating nickName : \(error.localizedDescription)")
                    completion(false, error)
                } else {
                    print("NickName successfully updated")
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = nickName
                    changeRequest?.commitChanges { error in
                        if let error = error {
                            print("Error updating user displayName : \(error.localizedDescription)")
                            completion(false, error)
                        } else {
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }
    
    /// 유저 프로필 이미지 업데이트
    /// - Parameter profileImage: 유저가 선택한 이미지
    func updateUserProfileImage(_ profileImage: UIImage, completion: @escaping (Bool, Error?) -> Void) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let data = profileImage.jpegData(compressionQuality: 0.5)
        
        guard let data = data else {
            print("프로필 이미지 data 변환 중 에러")
            return
        }
        
        if let uid = Auth.auth().currentUser?.uid {
            let profileImageRef = storageRef.child("profile_images/\(uid)")
            
            _ = profileImageRef.putData(data, metadata: nil) { metadata, error in
                if let error = error {
                    print("프로필 이미지 업로드 중 에러 \(error)")
                    completion(false, error)
                } else {
                    let size = metadata!.size
                    print("프로필 이미지 업로드 크기 : \(size)")
                    profileImageRef.downloadURL { url, error in
                        if let error = error {
                            print("프로필 이미지 다운로드 url 생성 중 에러 \(error)")
                            completion(false, error)
                        } else {
                            print("프로필 이미지 다운로드 url 생성 성공 : \(String(describing: url))")
                            self.uploadProfileImageURL(url!)
                            completion(true, nil)
                        }
                    }
                }
            }
        }
    }
    
    /// 프로필 이미지 URL firestore에 업데이트
    /// - Parameter url: 업데이트할 프로필 이미지 url
    func uploadProfileImageURL(_ url: URL) {
        let db = Firestore.firestore()
        if let uid = Auth.auth().currentUser?.uid {
            db.collection("users").document(uid).updateData([
                "profileImageURL" : url.absoluteString
            ]) { error in
                if let error = error {
                    print("프로필 이미지 URL 업로드 중 에러 : \(error)")
                } else {
                    print("프로필 이미지 URL 업로드 완료")
                }
            }
        }
    }
    
    /// 닉네임 유효성을 확인합니다
    /// - Parameter nickName: 유효성을 확인할 닉네임
    /// - Returns: 닉네임 유효성 확인 결과
    func isNickNameValid(_ nickName: String) -> Bool {
        var isNickNameValid = false
        var regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9가-힣]{2,14}$")
        isNickNameValid = regex.firstMatch(in: nickName, range: NSRange(location: 0, length: nickName.count)) != nil
        if isNickNameValid {
            regex = try! NSRegularExpression(pattern: "^[0-9]+$")
            isNickNameValid = !(regex.firstMatch(in: nickName, range: NSRange(location: 0, length: nickName.count)) != nil)
        } else {
            return false
        }
        return isNickNameValid
    }
    
    /// 닉네임 중복을 확인합니다
    /// - Parameter nickName: 중복을 확인할 닉네임
    /// - Returns: 닉네임 중복 확인 결과
    func isNickNameUnique(_ nickName: String) async throws -> Task<Bool, Error> {
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
