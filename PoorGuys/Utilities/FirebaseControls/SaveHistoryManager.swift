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
    func removeHistory(_ id: ID, on date: Date) async throws
    
    func fetchEncouragingWordsAndImages() async throws -> [EncouragingWordsAndImages]
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
    
    func removeHistory(_ id: ID, on date: Date) async throws {
        
    }
    
    func fetchEncouragingWordsAndImages() async throws -> [EncouragingWordsAndImages] {
        [EncouragingWordsAndImages(score: .spendOver100, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver50, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver20, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver5, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .zero, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveSome, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]) ,EncouragingWordsAndImages(score: .saveSome, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver5, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver20, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver50, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver100, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"])]
    }
}
