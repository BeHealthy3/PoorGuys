//
//  SaveHistoryView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryView<ViewModel: SaveHistoryViewModelProtocol>: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var isPresentingBottomSheet: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                saveHistoryCard()
                    .padding(.top, 33)
                savedHistoryList()
                Spacer()
            }
        }
        .onAppear {
            Task {
                try await viewModel.fetchAllHistories(on: Date())
                viewModel.calculateMyConsumptionScore()
                
                try await viewModel.fetchAllEncouragementWordsAndImages()
                viewModel.chooseRandomWordsAndImage()
            }
            
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    @ViewBuilder
    func saveHistoryCard() -> some View {
        VStack(spacing: 0) {
            Text(viewModel.encouragingWords)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(Color.appColor(.neutral900))
            
            AsyncImage(url: URL(string: viewModel.encouragingImageURL)) { phase in
                
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 24)
                        .padding(.horizontal, 48)
                @unknown default:
                    Color.appColor(.white)
                        .scaledToFit()
                        .padding(.vertical, 24)
                        .padding(.horizontal, 48)
                }
            }
            
            Text(viewModel.total > 0 ? "+" + viewModel.total.formatToCurrency() : viewModel.total.formatToCurrency())
                .font(.system(size: 36, weight: .black))
                .if(viewModel.total == 0) { view in
                    view
                        .foregroundColor(.appColor(.neutral700))
                }
                .if(viewModel.total > 0) { view in
                    view
                        .foregroundColor(.appColor(.primary500))
                }
                .if(viewModel.total < 0) { view in
                    view
                        .foregroundColor(.appColor(.red))
                }
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 32)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.appColor(.white))
                .shadow(color: Color(uiColor: UIColor(red: 0, green: 0.51, blue: 1, alpha: 0.2)) , radius: 10)
        }
    }

    @ViewBuilder
    func savedHistoryList() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text("06월 10일 (토)")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color.appColor(.neutral900))
                    .padding(.vertical, 24)
                Spacer()
                Button {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.isPresentingBottomSheet = true
                    }

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
            
            if #available(iOS 16.0, *) {
                List(viewModel.saveHistories) { saveHistory in
                    SaveHistoryRow(consumptionCategory: saveHistory.category, price: saveHistory.price)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(.horizontal, 32)
                .if(UIDevice.current.hasNotch) { view in
                    view.padding(.bottom, 104)
                }
                .if(!UIDevice.current.hasNotch) { view in
                    view.padding(.bottom, 84)
                }
            } else {
                List(viewModel.saveHistories) { saveHistory in
                    SaveHistoryRow(consumptionCategory: saveHistory.category, price: saveHistory.price)
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                .listStyle(.plain)
                .padding(.horizontal, 32)
                .if(UIDevice.current.hasNotch) { view in
                    view.padding(.bottom, 104)
                }
                .if(!UIDevice.current.hasNotch) { view in
                    view.padding(.bottom, 84)
                }
            }
        }
    }
}

struct SaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryView<MockSaveHistoryViewModel>(isPresentingBottomSheet: .constant(false))
    }
}
