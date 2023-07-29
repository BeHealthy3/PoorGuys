//
//  SaveHistoryRow.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryRow: View {
    let consumptionCategory: ConsumptionCategory
    let price: Int
    
    @State var iconColor = Color.appColor(.primary500)
    @State var textColor = Color.appColor(.red)
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CategoryIcon(consumptionCategory: consumptionCategory, saveHistoryViewMode: .constant(price >= 0 ? .saved : .wasted), isSelected: .constant(false))
                Spacer()
                HStack(alignment: .bottom, spacing: 4) {
                    Text(price > 0 ? "+" + price.formatToCurrency() : price.formatToCurrency())
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(textColor)
                    Text("원")
                        .font(.system(size: 14))
                        .foregroundColor(Color.appColor(.neutral900))
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 1)
            Divider()
        }
        .onAppear {
            if price >= 0 {
                textColor = Color.appColor(.primary500)
            } else {
                textColor = Color.appColor(.red)
            }
        }
    }
}
