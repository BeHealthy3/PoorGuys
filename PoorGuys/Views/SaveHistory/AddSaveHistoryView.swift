//
//  AddSaveHistoryView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/28.
//

import SwiftUI

struct AddSaveHistoryView: View {
    private enum FocusedField {
        case price
    }
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    @ObservedObject var viewModel: SaveHistoryViewModel
    @State private var selectedIcon: Int = 0
    @State private var saveState: SaveHistoryState = .saved
    @State private var price: String = ""
    @FocusState private var focusedField: FocusedField?
    
    var body: some View {
        ZStack {
            Color("primary050")
                .ignoresSafeArea()
            VStack(spacing: 0){
                segmentedControl()
                    .padding(.top, 32)
                selectCategory()
                    .padding(.top, 48)
                typePrice()
                    .padding(.top, 48)
                completedButton()
                    .padding(.top, 40)
            }
        }
        .onTapGesture {
            focusedField = nil
        }
    }
    
    @ViewBuilder
    func segmentedControl() -> some View {
        HStack {
            Button {
                self.saveState = .saved
                for i in viewModel.saveHistoryCategories.indices {
                    viewModel.saveHistoryCategories[i].state = .saved
                }
                viewModel.objectWillChange.send()
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                    if saveState == .saved {
                        Text("아낌 내역")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("white"))
                            .padding(.vertical, 6)
                    } else {
                        Text("아낌 내역")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("neutral_300"))
                            .padding(.vertical, 6)
                    }
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(self.saveState == .saved ? Color("primary_500") : Color("white"))
            }
            .padding(.leading, 4)
            .padding(.vertical, 4)
            
            Button {
                self.saveState = .wasted
                for i in viewModel.saveHistoryCategories.indices {
                    viewModel.saveHistoryCategories[i].state = .wasted
                }
                viewModel.objectWillChange.send()
            } label: {
                HStack(spacing: 0) {
                    Spacer()
                    if self.saveState == .saved {
                        Text("낭비 내역")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("neutral_500"))
                            .padding(.vertical, 6)
                    } else {
                        Text("낭비 내역")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(Color("white"))
                            .padding(.vertical, 6)
                    }
                    Spacer()
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(self.saveState == .saved ? Color("neutral_100") : Color("red"))
            }
            .padding(.trailing, 4)
            .padding(.vertical, 4)
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundColor(self.saveState == .saved ? Color("neutral_100") : Color("white"))
                .shadow(color: .black.opacity(0.05), radius: 5)
        }
        .padding(.horizontal, 16)
        
    }
    
    @ViewBuilder
    func selectCategory() -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // 아낌 내역
            if saveState == .saved {
                Text("어떤 지출을 아꼈는지 선택해 주세요")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                // 낭비 내역
            } else if saveState == .wasted {
                Text("어떤 지출을 했는지 선택해 주세요")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
            }
            
            LazyVGrid(columns: columns, alignment: .leading) {
                ForEach((0...11), id: \.self) { index in
                    Button {
                        self.selectedIcon = index
                    } label: {
                        CategoryIcon(saveHistory: viewModel.saveHistoryCategories[index], saveState: $saveState, isSelected: Binding(get: {selectedIcon == index}, set: {_ in } ))
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
            if saveState == .saved {
                Text("얼마를 아꼈는지 입력해 주세요")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
                // 낭비 내역
            } else if saveState == .wasted {
                Text("얼마를 낭비했는지 입력해 주세요")
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(Color("neutral_900"))
            }
            
            CurrencyTextField(title: "금액을 입력해 주세요", price: $price)
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    func completedButton() -> some View {
        Button {
            
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
                .foregroundColor(self.saveState == .saved ? Color("primary_500") : Color("red"))
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct AddSaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddSaveHistoryView(viewModel: SaveHistoryViewModel())
    }
}
