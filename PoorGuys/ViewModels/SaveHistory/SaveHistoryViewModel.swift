//
//  SaveHistoryViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

class SaveHistoryViewModel: ObservableObject {
    @Published var saveHistories: [SaveHistory] = [
        SaveHistory(category: .impulseBuy, state: .wasted, price: -8000),
        SaveHistory(category: .drink, state: .saved, price: +8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
    ]

}
