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
                        Text(notice.title)
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
