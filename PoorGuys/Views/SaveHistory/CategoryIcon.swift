//
//  CategoryIcon.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/28.
//

import SwiftUI

struct CategoryIcon: View {
    @State var consumptionCategory: ConsumptionCategory
    @Binding var saveHistoryViewMode: SaveHistoryViewMode
    @State var iconColor = Color.appColor(.primary500)
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Image(consumptionCategory.iconName)
                .renderingMode(.template)
                .foregroundColor(iconColor)
                .frame(width: 16, height: 16)
            Text(consumptionCategory.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            if isSelected {
                Capsule()
                    .foregroundColor(saveHistoryViewMode == .saved ? Color.appColor(.primary500) : Color.appColor(.neutral600))
            } else {
                ZStack {
                    
                    Capsule()
                        .foregroundColor(Color.appColor(.white))
                    Capsule()
                        .stroke(iconColor, lineWidth: 1)
                }
            }
        }
        .onAppear {
            giveButtonState()
        }
        .onChange(of: isSelected) { _ in
            giveButtonState()
        }
        .onChange(of: saveHistoryViewMode) { newValue in
            giveButtonState()
        }
    }
    
    private func giveButtonState() {
        switch saveHistoryViewMode {
        case .saved:
            iconColor = isSelected ? Color.appColor(.white) : Color.appColor(.primary500)
        case .wasted:
            iconColor = isSelected ? Color.appColor(.white) : Color.appColor(.neutral600)
        }
    }
}

//struct CategoryIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryIcon(saveHistory: SaveHistory(category: .food, state: .saved, price: 0))
//    }
//}
