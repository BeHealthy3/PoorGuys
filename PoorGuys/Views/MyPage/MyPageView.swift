//
//  MyPageView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/17.
//

import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var loginViewModel: LoginViewModel

    var body: some View {
        VStack {
            
            Button {
                loginViewModel.signOut()
            } label: {
                Text("로그아웃")
            }
        }
    }
}

struct MyPageView_Previews: PreviewProvider {
    static var previews: some View {
        MyPageView()
            .environmentObject(LoginViewModel())
    }
}
