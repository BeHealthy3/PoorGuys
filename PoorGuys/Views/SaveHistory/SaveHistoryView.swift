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
            VStack(spacing: 8) {
                saveHistoryCard()
                    .padding(.top, 33)
                    .padding(.horizontal, 16)
                    .if(!UIDevice.current.hasNotch, transform: { view in
                        view.frame(height: Constants.screenHeight * 0.53)
                    })
                    .if(UIDevice.current.hasNotch) { view in
                        view.frame(height: Constants.screenHeight * 0.47)
                    }
                
                savedHistoryList()
                Spacer()
            }
        }
        .onAppear {
            Task {
                // 두 개의 비동기 작업을 병렬로 실행
                let fetchAllHistoriesTask = Task.detached {
                    do {
                        try await viewModel.fetchAllHistories(on: Date())
                    } catch {
                        //todo: 에러처리
                    }
                }
                
                let fetchAllEncouragementWordsTask = Task.detached {
                    do {
                        try await viewModel.fetchAllEncouragementWordsAndImages()
                    } catch {
                        //todo: 에러처리
                    }
                }
                
                // 작업들이 완료될 때까지 기다립니다.
                await fetchAllHistoriesTask.value
                await fetchAllEncouragementWordsTask.value
                
                viewModel.calculateMyConsumptionScore()
                viewModel.chooseRandomWordsAndImage()
            }
            
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }
    
    @ViewBuilder
    private func saveHistoryCard() -> some View {
        VStack(spacing: 20) {
            Spacer()
            
            HStack {
                Spacer(minLength: 10)
                Text(viewModel.encouragingWords)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color.appColor(.neutral900))
                    .lineLimit(2)
                Spacer(minLength: 10)
            }
            
            
            AsyncImage(url: URL(string: viewModel.encouragingImageURL)) { phase in
                
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                    
                @unknown default:
                    Color.appColor(.white)
                        .scaledToFit()
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
                .padding(.bottom, 25)
        }
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.appColor(.white))
                .shadow(color: Color(uiColor: UIColor(red: 0, green: 0.51, blue: 1, alpha: 0.2)) , radius: 10)
        }
    }

    @ViewBuilder
    private func savedHistoryList() -> some View {
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
            
            DivergeView(
                if: viewModel.saveHistories.isEmpty,
                true: Text("아낌/낭비 리스트를 추가해 주세요!").foregroundColor(.appColor(.neutral400)).font(.system(size: 16, weight: .bold)).padding(.top, 15),
                false: SaveList()
            )
        }
    }
    
    @ViewBuilder
    private func SaveList() -> some View {
        if #available(iOS 16.0, *) {
            List(viewModel.saveHistories) { saveHistory in
                SaveHistoryRow(consumptionCategory: saveHistory.category, price: saveHistory.price)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .swipeActions {
                        Button(role: .destructive) {
                            print("삭제")
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
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
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                try await viewModel.removeHistory(id: saveHistory.id)
                                viewModel.calculateMyConsumptionScore()
                                viewModel.chooseRandomWordsAndImage()
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
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

struct SaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryView<MockSaveHistoryViewModel>(isPresentingBottomSheet: .constant(false))
    }
}
