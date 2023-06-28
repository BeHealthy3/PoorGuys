//
//  SaveHistoryRow.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryRow: View {
    @State var saveHistory: SaveHistory
    @State var iconColor = Color("primary_500")
    @State var textColor = Color("red")
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                CategoryIcon(saveHistory: saveHistory, saveState: $saveHistory.state, isSelected: .constant(false))
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
}

struct SaveHistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryRow(saveHistory: SaveHistory(category: .impulseBuy, state: .saved, price: -7000))
    }
}
