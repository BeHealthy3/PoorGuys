//
//  PoorGuysApp.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//
import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    // 파이어베이스 사용을 위한 초기 설정
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("Firebase...")
        FirebaseApp.configure()
        return true
    }
    
    // 구글 로그인 처리
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct PoorGuysApp: App {
    // 파이어베이스 설정을 위한 앱 델리게이트 등록
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    private var loginViewModel = LoginViewModel()
    
    var body: some Scene {
        WindowGroup {
//            MainView(saveHistoryViewModel: SaveHistoryViewModel())
//                .environmentObject(loginViewModel)
            CommunityView(viewModel: CommunityViewModel())
        }
    }
}
