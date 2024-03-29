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
    @State private var isPresentingAddSaveHistoryView = false
    @State private var isPresentingExportingHisotoryView = false
    
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
                            
                            SaveHistoryView<SaveHistoryViewModel>(isPresentingAddSaveHistoryView: $isPresentingAddSaveHistoryView, isPresentingExportingHistoryView: $isPresentingExportingHisotoryView)
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
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        isPresentingAddSaveHistoryView = false
                                    }
                                }
                            CustomBottomSheet(
                                content: AddSaveHistoryView<SaveHistoryViewModel>(
                                    isPresenting: $isPresentingAddSaveHistoryView
                                )
                            .environmentObject(saveHistoryViewModel), withNotchHeight: 500, withoutNotchheight: 490)
                            .transition(.bottomToTop)
                        }
                        
                        if isPresentingExportingHisotoryView {
                            Color.black
                                .opacity(0.5)
                                .ignoresSafeArea()
                                .onTapGesture {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        isPresentingExportingHisotoryView = false
                                    }
                                }
                            
                            CustomBottomSheet(content: ExportingSaveHistoryView<SaveHistoryViewModel>(
                                isPresenting: $isPresentingExportingHisotoryView
                            ), withNotchHeight: 653, withoutNotchheight: 628)
                            .environmentObject(saveHistoryViewModel)
                            .transition(.bottomToTop)
                        }
                    }
                }
            }
        }
        .preferredColorScheme(.light)   // 기기 다크모드여도 앱은 라이트모드 적용
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(saveHistoryViewModel: MockSaveHistoryViewModel())
            .environmentObject(LoginViewModel())
    }
}
