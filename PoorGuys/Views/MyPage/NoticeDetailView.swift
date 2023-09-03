//
//  NoticeDetailView.swift
//  PoorGuys
//
//  Created by 권승용 on 9/3/23.
//

import SwiftUI

struct NoticeDetailView: View {
    let notice: Notice
    var body: some View {
        VStack(spacing: 0) {
            CustomNavigationBar(title: "공지사항")
                .padding(.bottom, 16)
            titleText()
                .padding(.bottom, 8)
            bodyText()
                .padding(.bottom, 8)
            timeStamp()
            Spacer()
        }
        
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func titleText() -> some View {
        HStack {
            Text(notice.title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(Color("neutral_900"))
            Spacer()
        }
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func bodyText() -> some View {
        Text(notice.body)
            .font(.system(size: 16))
            .foregroundColor(Color("neutral_800"))
            .lineSpacing(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private func timeStamp() -> some View {
        HStack {
            Spacer()
            Text(formattedDate())
                .font(.system(size: 12))
                .foregroundColor(Color("neutral_500"))
        }
        .padding(.horizontal, 24)
    }
    
    private func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        
        return formatter.string(from: notice.timeStamp)
    }
}

#Preview {
    NoticeDetailView(notice: Notice(id: nil, timeStamp: Date.now, title: "8월 15일 광복절 안내", body: "안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여안녕하세요 어푸어푸 관리자입니당.  8월15일 광복절을 맞이하여"))
}
