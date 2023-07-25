//
//  SaveHistoryViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

class SaveHistoryViewModel: ObservableObject {
    @Published var date = Date()
    @Published var total = 0
    
    @Published var saveHistories: [SaveHistory] = [
        SaveHistory(category: .impulseBuy, state: .wasted, price: -8000),
        SaveHistory(category: .drink, state: .saved, price: +8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000)
    ]
    
    @Published var saveHistoryCategories: [SaveHistory] = [
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
}
