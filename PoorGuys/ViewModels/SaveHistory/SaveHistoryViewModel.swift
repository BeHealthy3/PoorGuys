//
//  SaveHistoryViewModel.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

protocol SaveHistoryViewModelProtocol: ObservableObject, ViewModelable {
    var date: Date { get set }
    var total: Int { get set }
    var saveHistories: [SaveHistory] { get set }
    
    func addHistory(_ history: SaveHistory, on date: Date) async throws
    
    func fetchAllHistories(on date: Date) async throws
    
    func removeHistory(id: ID) async throws
}

class MockSaveHistoryViewModel: SaveHistoryViewModelProtocol, ObservableObject {
    @Published var date: Date = Date()
    @Published var total: Int = 0
    @Published var saveHistories: [SaveHistory] = []
    
    func addHistory(_ history: SaveHistory, on date: Date) async throws {
//        네트워킹
        sleep(1)
        saveHistories.append(history)
    }
    
    func fetchAllHistories(on date: Date) async throws {
        sleep(1)
        for _ in 0...Int.random(in: 0...10) {
            saveHistories.append(SaveHistory.dummy())
        }
    }
    
    func removeHistory(id: ID) async throws {
//        네트워킹
        sleep(1)
        saveHistories.removeAll { $0.id == id }
    }
}

class SaveHistoryViewModel: ObservableObject {
    @Published var date = Date()
    @Published var total = 0
    
    @Published var saveHistories: [SaveHistory] = [
//        SaveHistory(category: .impulseBuy, state: .wasted, price: -8000),
//        SaveHistory(category: .drink, state: .saved, price: +8000),
//        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
//        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
//        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000),
//        SaveHistory(category: .impulseBuy, state: .wasted, price: 8000)
        
        
//        SaveHistory(category: .impulseBuy, price: -8000),
//        SaveHistory(category: .drink, price: 8000),
//        SaveHistory(category: .impulseBuy, price: 8000),
//        SaveHistory(category: .impulseBuy, price: 8000),
//        SaveHistory(category: .impulseBuy, price: 8000),
//        SaveHistory(category: .impulseBuy, price: 8000)
    ]
    
//    @Published var saveHistoryCategories: [SaveHistory] = [
////        SaveHistory(category: .transport, state: .saved, price: 0),
////        SaveHistory(category: .food, state: .saved, price: 0),
////        SaveHistory(category: .shopping, state: .saved, price: 0),
////        SaveHistory(category: .impulseBuy, state: .saved, price: 0),
////        SaveHistory(category: .dessert, state: .saved, price: 0),
////        SaveHistory(category: .hobby, state: .saved, price: 0),
////        SaveHistory(category: .subscribtion, state: .saved, price: 0),
////        SaveHistory(category: .mobileGame, state: .saved, price: 0),
////        SaveHistory(category: .coffee, state: .saved, price: 0),
////        SaveHistory(category: .present, state: .saved, price: 0),
////        SaveHistory(category: .drink, state: .saved, price: 0),
////        SaveHistory(category: .secondHandDealings, state: .saved, price: 0)
//        SaveHistory(category: .transport, price: 0),
//        SaveHistory(category: .food, price: 0),
//        SaveHistory(category: .shopping, price: 0),
//        SaveHistory(category: .impulseBuy, price: 0),
//        SaveHistory(category: .dessert, price: 0),
//        SaveHistory(category: .hobby, price: 0),
//        SaveHistory(category: .subscribtion, price: 0),
//        SaveHistory(category: .mobileGame, price: 0),
//        SaveHistory(category: .coffee, price: 0),
//        SaveHistory(category: .present, price: 0),
//        SaveHistory(category: .drink, price: 0),
//        SaveHistory(category: .secondHandDealings, price: 0)
//    ]
    
    func addHistory(_ history: SaveHistory) async throws {
        
    }
    
    func fetchAllHistories(on date: Date) {
        
    }
    
    func removeHistory(id: ID) {
        
    }
}


