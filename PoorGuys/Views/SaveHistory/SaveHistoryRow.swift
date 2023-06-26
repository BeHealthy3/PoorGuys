//
//  SaveHistoryRow.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryRow: View {
    let saveHistory: SaveHistory
    @State var iconColor = Color("primary_500")
    @State var textColor = Color("red")
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                categoryIcon()
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    Text("\(saveHistory.price)")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(textColor)
                    Text("원")
                        .font(.system(size: 14))
                        .foregroundColor(Color("neutral_900"))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 1)
            Divider()
        }
    }
    
    @ViewBuilder
    func categoryIcon() -> some View {
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
            RoundedRectangle(cornerRadius: 12)
                .stroke(iconColor, lineWidth: 1)
        }
        .onAppear {
            switch saveHistory.state {
            case .saved:
                iconColor = Color("primary_500")
                textColor = Color("primary_500")
            case .wasted:
                iconColor = Color("neutral_600")
                textColor = Color("red")
            case .selected:
                iconColor = Color("white")
            }
        }
    }
}

struct SaveHistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryRow(saveHistory: SaveHistory(category: .impulseBuy, state: .saved, price: -7000))
    }
}
