//
//  SaveHistoryManager.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/26.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

protocol SaveHistoryManagable {
    func createNewHistory(_ history: SaveHistory, on date: Date) async throws
    func fetchAllHistories(on date: Date) async throws -> [SaveHistory]
    func updateHistories(with histories: [SaveHistory], on date: Date) async throws
}

struct SaveHistoryManager: SaveHistoryManagable {
    
    let uid: String
    let strHistories = "histories"
    let strDate = "date"
    
    init(uid: String) {
        self.uid = uid
    }
    
    private let historiesCollection = Firestore.firestore().collection("histories")
    
    func createNewHistory(_ history: SaveHistory, on date: Date) async throws {
        let date = date.dotted()
        let dateDocumentRef = historiesCollection.document(uid).collection(strDate).document(date)
        let documentSnapshot = try await dateDocumentRef.getDocument()
        
        if documentSnapshot.exists {
            guard var data = documentSnapshot.data() else { throw FirebaseError.documentNotFound }
            
            if var histories = data[strHistories] as? [[String: Any]] {
                
                histories.append(history.asDictionary())
                data[strHistories] = histories
                
                try await dateDocumentRef.setData(data)
            }
        } else {
            let newDocumentData: [String : Any] = [strHistories : [history.asDictionary()]]
            try await dateDocumentRef.setData(newDocumentData)
        }
    }
    
    func fetchAllHistories(on date: Date) async throws -> [SaveHistory] {
        let date = date.dotted()
        let dateDocumentRef = historiesCollection.document(uid).collection(strDate).document(date)
        let documentSnapshot = try await dateDocumentRef.getDocument()
        
        if documentSnapshot.exists {
            guard var data = documentSnapshot.data() else { throw FirebaseError.documentNotFound }
            
            if let historiesArray = data[strHistories] as? [[String: Any]] {
                let histories = historiesArray.compactMap { dict -> SaveHistory? in
                    guard let categoryNumber = dict["category"] as? Int,
                          let id = dict["id"] as? String,
                          let price = dict["price"] as? Int,
                          let category = ConsumptionCategory(rawValue: categoryNumber) else {
                        return nil
                    }
                    return SaveHistory(id: id, category: category, price: price)
                }
                return histories
            } else {
                let newDocumentData: [String: Any] = [strHistories: []]
                
                try await dateDocumentRef.setData(newDocumentData)
                
                return []
            }
            
        } else {
            return []
        }
    }
    
    func updateHistories(with histories: [SaveHistory], on date: Date) async throws {
        
        let date = date.dotted()
        let dateDocumentRef = historiesCollection.document(uid).collection(strDate).document(date)
        let historiesData: [[String: Any]] = histories.map { history in
                return [
                    "category": history.category.rawValue,
                    "id": history.id,
                    "price": history.price
                ]
            }
        
        try await dateDocumentRef.updateData([strHistories : historiesData])
    }
}

struct MockSaveHistoryManager: SaveHistoryManagable {
    
    func createNewHistory(_ history: SaveHistory, on date: Date) async throws {
        
    }
    
    func fetchAllHistories(on date: Date) async throws -> [SaveHistory] {
        var histories: [SaveHistory] = []
        if Int.random(in: 1...2).isMultiple(of: 2) {
            for _ in (0...Int.random(in: 0...5)) {
                histories.append(SaveHistory.dummy())
            }
        }
        return histories
    }
    
    func updateHistories(with histories: [SaveHistory], on date: Date) async throws {
        
    }
}
