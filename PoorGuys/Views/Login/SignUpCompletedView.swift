//
//  SignUpCompletedView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/05/16.
//

import SwiftUI

struct SignUpCompletedView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("가입이 완료되었습니다!")
            Text("거지방에서 즐거운 시간 보내세요~!")
            Spacer()
            toMainViewButton()
                .padding(.bottom, 40)
        }
    }
    
    @ViewBuilder
    func toMainViewButton() -> some View {
        Button {
            /* TODO : 첫 로그인 완료 */
        } label: {
            Text("완료")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 16)
        }
    }
}

struct SignUpCompletedView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpCompletedView()
    }
}
