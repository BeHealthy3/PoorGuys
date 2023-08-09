//
//  AddSaveHistoryView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/28.
//

import SwiftUI

struct AddSaveHistoryView<ViewModel: SaveHistoryViewModelProtocol>: View {
    private enum FocusedField {
        case price
    }
    
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var keyboardHandler: KeyboardHandler = KeyboardHandler()
    
    @State private var selectedIcon: Int = 0
    @State private var saveHistoryViewMode = SaveHistoryViewMode.saved
    @State private var price: String = ""
    @FocusState private var focusedField: FocusedField?
    @Binding var isPresenting: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { proxy in
                ZStack() {
                    Color.appColor(.primary050)
                        .ignoresSafeArea()
                    VStack(spacing: 0){
                        segmentedControl()
                            .padding(.top, 32)
                        selectCategory()
                            .padding(.top, 48)
                        typePrice()
                            .padding(.top, 48)
                            .padding(.bottom, 40)
                        completedButton()
                            .background(Color.appColor(.primary900))
                            .padding(.bottom, keyboardHandler.keyboardHeight)
                            .id("bottomButton")
                    }
                }
                .onTapGesture {
                    withAnimation {
                        focusedField = nil
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
                }
                .onChange(of: keyboardHandler.keyboardHeight) { bottomPadding in
                    if bottomPadding != 0 {
                        withAnimation {
                            proxy.scrollTo("bottomButton")
                        }
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    func segmentedControl() -> some View {
        HStack {
            Button {
                self.saveHistoryViewMode = .saved
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                    Text("아낌 내역")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(saveHistoryViewMode == .saved ? .appColor(.white) : .appColor(.neutral300))
                        .padding(.vertical, 6)
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(self.saveHistoryViewMode == .saved ? Color.appColor(.primary500) : Color.appColor(.white))
            }
            .padding(.leading, 4)
            .padding(.vertical, 4)
            
            Button {
                self.saveHistoryViewMode = .wasted
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                    Text("낭비 내역")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(saveHistoryViewMode == .saved ? .appColor(.neutral500) : .appColor(.white))
                        .padding(.vertical, 6)
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(self.saveHistoryViewMode == .saved ? Color.appColor(.neutral100) : Color.appColor(.red))
            }
            .padding(.trailing, 4)
            .padding(.vertical, 4)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(self.saveHistoryViewMode == .saved ? Color.appColor(.neutral100) : Color.appColor(.white))
                .shadow(color: .black.opacity(0.05), radius: 5)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func selectCategory() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 아낌 내역
            Text("어떤 지출을 \(saveHistoryViewMode == .saved ? "아꼈는지" : "했는지") 선택해 주세요")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.appColor(.neutral900))
            
            let rows = 3
            let columns = 4
            
            VStack(alignment: .leading,spacing: 8) {
//                lazy grid로 만들면 뷰가 늦게 생성되어 애니메이션에 영향을 주어 변경
                ForEach(0..<rows, id: \.self) { rowIndex in
                    HStack(spacing: 10) {
                        ForEach(0..<columns, id: \.self) { columnIndex in
                            let index = rowIndex * columns + columnIndex
                            Button(action: {
                                selectedIcon = index
                            }, label: {
                                if let saveCategory = ConsumptionCategory(rawValue: index) {
                                    CategoryIcon(consumptionCategory: saveCategory, saveHistoryViewMode: $saveHistoryViewMode, isSelected: Binding(get: {selectedIcon == index}, set: { _ in } ))
                                }
                            })
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func typePrice() -> some View {
        VStack(alignment: .leading) {
            // 아낌 내역
            Text("얼마를 \(saveHistoryViewMode == .saved ? "아꼈는지" : "낭비했는지") 입력해 주세요")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(Color.appColor(.neutral900))
            
            CurrencyTextField(title: "금액을 입력해 주세요", price: $price)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func completedButton() -> some View {
        Button {
            Task {
                do {
                    guard let category = ConsumptionCategory(rawValue: selectedIcon), let price = price.removeCommasAndConvertToInt() else { return }
                    
                    try await viewModel.addHistory(SaveHistory(id: UUID().uuidString, category: category, price: saveHistoryViewMode == .saved ? price : -price))
                    viewModel.calculateMyConsumptionScore()
                    viewModel.chooseRandomWordsAndImage()
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        isPresenting = false
                    }
                    
                } catch {
                    print("업로드 실패") //todo: 에러처리
                }
            }
        } label: {
            HStack {
                Spacer()
                Text("완료")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(Color("white"))
                    .padding(.vertical, 16)
                    .padding(.bottom, 17)
                Spacer()
            }
        }
        .background {
            Rectangle()
                .if(saveHistoryViewMode == .saved) { view in
                    view.foregroundColor(price == "" ? .appColor(.primary100) : .appColor(.primary500))
                }
                .if(saveHistoryViewMode == .wasted) { view in
                    view.foregroundColor(price == "" ? .appColor(.lightRed) : .appColor(.red))
                }
        }
        .edgesIgnoringSafeArea(.bottom)
        .disabled(price == "")
    }
}

