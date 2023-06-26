//
//  SaveHistoryViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

class SaveHistoryViewModel: ObservableObject {
    @Published var saveHistories: [SaveHistory] = [
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
        SaveHistory(category: .impulseBuy, price: 8000),
    ]
}
