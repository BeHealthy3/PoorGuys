//
//  SaveHistoryViewFullScroll.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryViewFullScroll: View {
    @StateObject var viewModel = SaveHistoryViewModel()
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                saveHistoryCard()
                    .padding(.top, 33)
                savedHistoryList()
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func saveHistoryCard() -> some View {
        VStack(spacing: 0) {
            Text("코코야 폼 미쳤다!")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color("neutral_900"))
            Image("imageExample")
                .resizable()
                .scaledToFit()
                .padding(.vertical, 24)
                .padding(.horizontal, 48)
            Text("+50,000")
                .font(.system(size: 36, weight: .black))
        }
        .padding(.vertical, 24)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color("white"))
                .shadow(color: Color(uiColor: UIColor(red: 0, green: 0.51, blue: 1, alpha: 0.2)) , radius: 10)
        }
        .padding(.horizontal, 32)
    }
    
    @ViewBuilder
    func savedHistoryList() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("06월 10일 (토)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                    .padding(.vertical, 24)
                Spacer()
                Button {
                    
                } label: {
                    Text("추가")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(Color("white"))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                        }
                }
            }
            .padding(.horizontal, 32)
            ForEach(viewModel.saveHistories) { saveHistory in
                SaveHistoryRow(saveHistory: saveHistory)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(.horizontal, 32)
            }
        }
    }
}

struct SaveHistoryViewFullScroll_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryViewFullScroll()
    }
}
