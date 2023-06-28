//
//  CategoryIcon.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/28.
//

import SwiftUI

struct CategoryIcon: View {
    @State var saveHistory: SaveHistory
    @Binding var saveState: SaveHistoryState
    @State var iconColor = Color("primary_500")
    @Binding var isSelected: Bool
    
    var body: some View {
        HStack(spacing: 2) {
            Image(saveHistory.category.iconName)
                .renderingMode(.template)
                .foregroundColor(iconColor)
                .frame(width: 16, height: 16)
            Text(saveHistory.category.categoryName)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(iconColor)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background {
            if isSelected {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(saveState == .saved ? Color("primary_500") : Color("neutral_600"))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(iconColor, lineWidth: 1)
            }
        }
        .onAppear {
            switch saveState {
            case .saved:
                iconColor = isSelected ? Color("white") : Color("primary_500")
            case .wasted:
                iconColor = isSelected ? Color("white") : Color("neutral_600")
            }
        }
        .onChange(of: isSelected) { newValue in
            switch saveState {
            case .saved:
                iconColor = isSelected ? Color("white") : Color("primary_500")
            case .wasted:
                iconColor = isSelected ? Color("white") : Color("neutral_600")
            }
        }
    }
}

//struct CategoryIcon_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryIcon(saveHistory: SaveHistory(category: .food, state: .saved, price: 0))
//    }
//}
