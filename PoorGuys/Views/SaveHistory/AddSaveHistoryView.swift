//
//  AddSaveHistoryView.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/28.
//

import SwiftUI

struct AddSaveHistoryView: View {
    
    @State var saveState: SaveHistoryState = .saved
    var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 4)
    
    var saveHistoryCategories: [SaveHistory] = [
        SaveHistory(category: .transport, state: .saved, price: 0),
        SaveHistory(category: .food, state: .saved, price: 0),
        SaveHistory(category: .shopping, state: .saved, price: 0),
        SaveHistory(category: .impulseBuy, state: .saved, price: 0),
        SaveHistory(category: .dessert, state: .saved, price: 0),
        SaveHistory(category: .hobby, state: .saved, price: 0),
        SaveHistory(category: .subscribtion, state: .saved, price: 0),
        SaveHistory(category: .mobileGame, state: .saved, price: 0),
        SaveHistory(category: .coffee, state: .saved, price: 0),
        SaveHistory(category: .present, state: .saved, price: 0),
        SaveHistory(category: .drink, state: .saved, price: 0),
        SaveHistory(category: .secondHandDealings, state: .saved, price: 0)
    ]
    @State var selectedIcon: Int = 0
    
    var body: some View {
        VStack {
            /* TODO : 아낌 / 낭비 내역 토글 */
            
            selectCategory()
            typePrice()
        }
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
                        CategoryIcon(saveHistory: saveHistoryCategories[index], saveState: $saveState, isSelected: Binding(get: {selectedIcon == index}, set: {_ in } ))
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
        }
    }
}

struct AddSaveHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        AddSaveHistoryView()
    }
}
