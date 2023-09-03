//
//  NoticeView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/09/02.
//

import SwiftUI

struct NoticeView: View {
    @StateObject var viewModel = NoticeViewModel()
    @State var isViewLoaded = false
    
    var body: some View {
        VStack {
            CustomNavigationBar(title: "공지사항")
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.notices, id: \.id) { notice in
                        noticeDetail(notice: notice)
                    }
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
            }
            .refreshable {
                await refresh()
            }
        }
        .onAppear {
            Task {
                if !isViewLoaded {
                    await fetchNotices()
                    isViewLoaded = true
                } else {
                    await refresh()
                }
            }
        }
        
        .navigationBarHidden(true)
    }
    
    @ViewBuilder
    private func noticeDetail(notice: Notice) -> some View {
        NavigationLink(destination: NoticeDetailView(notice: notice)) {
            HStack {
                Text(notice.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                Spacer()
            }
            .padding(.vertical, 26)
            .padding(.leading, 16)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(Color("white"))
                    .shadow(color: .black.opacity(0.07), radius: 5, x: 0, y: 0)
            }
            .overlay {
                HStack {
                    Spacer()
                    VStack {
                        timeStamp(notice.timeStamp)
                            .padding(.top, 8)
                            .padding(.trailing, 8)
                        Spacer()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func timeStamp(_ date: Date) -> some View {
        Text(formattedDate(date))
            .font(.system(size: 12))
            .foregroundColor(Color("neutral_500"))
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    private func fetchNotices() async {
        do {
            try await viewModel.fetchNotices()
        } catch {
            print("공지사항 가져오기 실패")
        }
    }
    
    private func refresh() async {
        do {
            viewModel.removeNotices()
            try await viewModel.fetchNotices()
        } catch {
            print("공지사항 가져오기 실패")
        }
    }
}

struct NoticeView_Previews: PreviewProvider {
    static var previews: some View {
        NoticeView()
    }
}
