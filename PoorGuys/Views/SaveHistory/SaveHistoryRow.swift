//
//  SaveHistoryRow.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import SwiftUI

struct SaveHistoryRow: View {
    let saveHistory: SaveHistory
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Image(saveHistory.category.iconName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 32)
                    .padding(.vertical, 16)
                Spacer()
                Text("\(saveHistory.price)")
                Text("원")
            }
            Divider()
        }
    }
}

struct SaveHistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        SaveHistoryRow(saveHistory: SaveHistory(category: .impulseBuy, price: -7000))
    }
}
