//
//  ContactView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/09/02.
//

import SwiftUI

struct ContactView: View {
    
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "문의하기")
            noticeText()
                .padding(.vertical, 16)
            emailToContact()
                .padding(.bottom, 24)
            bottomNoticeText()
            Spacer()
        }
        
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    func noticeText() -> some View {
        Text(Constants.contactNotice)
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(Color(red: 0.13, green: 0.16, blue: 0.18))
            .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    func emailToContact() -> some View {
        VStack(spacing: 10) {
            HStack(spacing: 4) {
                Text("👇")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.black)
                Text("(클릭하여 복사해 주세요)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color("neutral_900"))
                Spacer()
            }
            .padding(.horizontal, 24)
            
            Text(verbatim: "0000000@naver.com")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color("neutral_900"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color("neutral_050"))
                        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 0)
                }
                .padding(.horizontal, 16)
                .onTapGesture {
                    // TODO: 리얼 디바이스에서 클립보드로 복사 잘 되는지 확인
                    UIPasteboard.general.setValue("0000@naver.com", forPasteboardType: "public.plain-text")
                }
        }
    }
    
    @ViewBuilder
    func bottomNoticeText() -> some View {
        Text("영업일 3일 이내로 확인하여 답변드릴 예정이며, 어푸어푸 서비스를 이용해주셔서 감사드립니다.")
            .font(.system(size: 14))
            .foregroundColor(Color("neutral_700"))
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
    }
 
}

struct ContactView_Previews: PreviewProvider {
    static var previews: some View {
        ContactView()
    }
}
