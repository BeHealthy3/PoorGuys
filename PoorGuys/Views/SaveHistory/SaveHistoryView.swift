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
                ZStack(alignment: .topTrailing) {
                    SaveHistoryCardView(viewModel: _viewModel)
                        .background {
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color.appColor(.white))
                                .shadow(color: .black.opacity(0.1) , radius: 12)
                        }
                        .padding(.top, 33)
                        .padding(.horizontal, 16)
                        .if(!UIDevice.current.hasNotch, transform: { view in
                            view.frame(height: Constants.screenHeight * 0.53)
                        })
                        .if(UIDevice.current.hasNotch) { view in
                            view.frame(height: Constants.screenHeight * 0.47)
                        }
                    
                    Button {
                        print("export button tapped")
                    } label: {
                        Image("exportButton")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 24, height: 24)
                    }
                    .padding(.top, 57)
                    .padding(.trailing, 32)
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
                
                // 작업들이 완료될 때까지 기다림
                await fetchAllHistoriesTask.value
                await fetchAllEncouragementWordsTask.value
                
                viewModel.calculateMyConsumptionScore()
                viewModel.chooseRandomWordsAndImage()
            }
            
            UITableView.appearance().showsVerticalScrollIndicator = false
        }
    }

    @ViewBuilder
    private func savedHistoryList() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(DateFormatter().toKorean(from: viewModel.date))
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
