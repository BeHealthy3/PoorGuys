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
    mutating func createNewHistory(_ history: SaveHistory, on date: Date) async throws
    mutating func fetchAllHistories(on date: Date) async throws -> [SaveHistory]
    mutating func removeHistory(_ id: ID, on date: Date) async throws
}

struct SaveHistoryManager: SaveHistoryManagable {
    
    let uid: String
    
    init(uid: String) {
        self.uid = uid
    }
    
    private lazy var dateCollection = Firestore.firestore().collection("histories").document(uid).collection("date")
    
    mutating func createNewHistory(_ history: SaveHistory, on date: Date) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let date = dateFormatter.string(from: Date())
        let dateDocumentRef = dateCollection.document(date)
        let documentSnapshot = try await dateDocumentRef.getDocument()
        
        if documentSnapshot.exists {
            guard var data = documentSnapshot.data() else { throw FirebaseError.documentNotFound }
            
            if var histories = data["histories"] as? [[String: Any]] {
                
                histories.append(history.asDictionary())
                data["histories"] = histories
                
                try await dateDocumentRef.setData(data)
            }
        } else {
            let newDocumentData: [String : Any] = ["histories" : [history.asDictionary()]]
            try await dateDocumentRef.setData(newDocumentData)
        }
    }
    
    func fetchAllHistories(on date: Date) async throws -> [SaveHistory] {
        []
    }
    
    func removeHistory(_ id: ID, on date: Date) async throws {
        
    }
}

struct MockSaveHistoryManager: SaveHistoryManagable {
    
    mutating func createNewHistory(_ history: SaveHistory, on date: Date) async throws {
        
    }
    
    mutating func fetchAllHistories(on date: Date) async throws -> [SaveHistory] {
        var histories: [SaveHistory] = []
        if Int.random(in: 1...2).isMultiple(of: 2) {
            for _ in (0...Int.random(in: 0...5)) {
                histories.append(SaveHistory.dummy())
            }
        }
        return histories
    }
    
    mutating func removeHistory(_ id: ID, on date: Date) async throws {
        
    }
}
