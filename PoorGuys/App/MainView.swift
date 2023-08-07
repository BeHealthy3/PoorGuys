//
//  ContentView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI
import FirebaseAuth

struct MainView<SaveHistoryViewModel: SaveHistoryViewModelProtocol>: View {

    @EnvironmentObject var logInViewModel: LoginViewModel
    @StateObject var saveHistoryViewModel: SaveHistoryViewModel
    
    @State private var isShowingLaunchScreen = true
    @State private var selection: String = "community"
    @State private var tabSelection: TabBarItem = .community
    @State var isPresentingAddSaveHistoryView = false
    
    init(saveHistoryViewModel: SaveHistoryViewModel) {
        _saveHistoryViewModel = StateObject(wrappedValue: saveHistoryViewModel)
    }
    
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
                                    DispatchQueue.main.async {
                                        logInViewModel.signInState = .signedIn
                                    }
                                } else {
                                    isShowingLaunchScreen = false
                                    DispatchQueue.main.async {
                                        logInViewModel.signInState = .signedOut
                                    }
                                }
                            }
                        }
                    }
            } else {
                // 로그아웃 되어있거나, 닉네임 설정되어 있지 않으면 로그인 뷰 보이기
                if logInViewModel.signInState == .signedOut || !logInViewModel.didSetNickName {
                    LoginView()
                } else {
                    ZStack {
                        CustomTabBarContainerView(selection: $tabSelection) {
                            CommunityView(viewModel: CommunityViewModel())
                                .tabBarItem(tab: .community, selection: $tabSelection)
                            
                            SaveHistoryView<SaveHistoryViewModel>(isPresentingBottomSheet: $isPresentingAddSaveHistoryView)
                                .environmentObject(saveHistoryViewModel)
                                .tabBarItem(tab: .saveHistory, selection: $tabSelection)
                            
                            Text("알림 탭")
                                .tabBarItem(tab: .alert, selection: $tabSelection)
                        }
                        .edgesIgnoringSafeArea(.bottom)
                        
                        if isPresentingAddSaveHistoryView {
                            Color.black
                                .opacity(0.5)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        isPresentingAddSaveHistoryView = false
                                    }
                                }
                            
                            CustomBottomSheet(content: AddSaveHistoryView<SaveHistoryViewModel>(isPresenting: $isPresentingAddSaveHistoryView).environmentObject(saveHistoryViewModel))
                                .transition(.bottomToTop)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light)   // 기기 다크모드여도 앱은 라이트모드 적용
//        .onAppear {
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
//                if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
//                    keyboardHeight = keyboardFrame.height
//                }
//            }
//
//            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
//                keyboardHeight = 0
//            }
//        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(saveHistoryViewModel: MockSaveHistoryViewModel())
            .environmentObject(LoginViewModel())
    }
}


import Combine

class KeyboardHandler: ObservableObject {
    @Published var keyboardHeight: CGFloat = 0

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardHeight = keyboardFrame.height
            print(keyboardHeight, "😊")
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        keyboardHeight = 0
        print(keyboardHeight, "🥩")
    }
}
