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
    var encouragingWordsAndImagesCollection: [EncouragingWordsAndImages] { get }
    var encouragingWords: String { get set }
    var encouragingImageURL: String { get set }
    var myScore: ConsumptionScore { get set }
    
    func addHistory(_ history: SaveHistory, on date: Date) async throws
    
    func fetchAllHistories(on date: Date) async throws
    
    func removeHistory(id: ID) async throws
    
    func fetchAllEncouragementWordsAndImages() async throws
}

extension SaveHistoryViewModelProtocol {
    func chooseRandomWordsAndImage() {
        let encouragingWordsAndImages = encouragingWordsAndImagesCollection.first { encouragingWordsAndImages in
            encouragingWordsAndImages.score == myScore
        }
        
        encouragingWords = encouragingWordsAndImages?.words.randomElement() ?? ""
        encouragingImageURL = encouragingWordsAndImages?.images.randomElement() ?? ""
    }
    
    func calculateMyConsumptionScore() {
        saveHistories.forEach { history in
            total += history.price
        }
        
        myScore = seperateConsumptionScore(from: total)
    }
    
    private func seperateConsumptionScore(from amount: Int) -> ConsumptionScore {
        switch amount {
        case ...(-100000):
            return .spendOver100
        case -99999 ... -50000:
            return .spendOver50
        case -49999 ... -20000:
            return .spendOver20
        case -19999 ... -5000:
            return .spendOver5
        case -4999 ... -1000:
            return .spendSome
        case 0:
            return .zero
        case 1000 ... 4999:
            return .saveSome
        case 5000 ... 19999:
            return .saveOver5
        case 20000 ... 49999:
            return .saveOver20
        case 50000 ... 99999:
            return .saveOver50
        default:
            return .saveOver100
        }
    }
}

class MockSaveHistoryViewModel: SaveHistoryViewModelProtocol, ObservableObject {
    @Published var date: Date = Date()
    @Published var total: Int = 0
    @Published var saveHistories: [SaveHistory] = []
    @Published var encouragingWordsAndImagesCollection: [EncouragingWordsAndImages] = []
    @Published var encouragingWords: String = ""
    @Published var encouragingImageURL: String = ""
    var myScore: ConsumptionScore = .zero
    
    func fetchAllEncouragementWordsAndImages() async throws {
        sleep(1)
        encouragingWordsAndImagesCollection = [EncouragingWordsAndImages(score: .spendOver100, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .spendOver50, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .spendOver20, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .spendOver5, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .zero, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .spendSome, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]) ,EncouragingWordsAndImages(score: .saveSome, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .saveOver5, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .saveOver20, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .saveOver50, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"]), EncouragingWordsAndImages(score: .saveOver100, words: ["너 돈 너무 많이 썼다;", "와 벼락거지 탄생!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F0B902165-81F8-49C8-820B-3B5CA1F3E7BD.png?alt=media&token=f249b7d1-00fd-4caf-9202-5593f970b624", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F3E32922D-D5EE-44F1-9B02-B4AF280B7F46.png?alt=media&token=b1d6cf53-4e83-46a3-85ca-0f6e164501c3"])]
    }
    
    func addHistory(_ history: SaveHistory, on date: Date) async throws {
//        네트워킹
        sleep(1)
        saveHistories.append(history)
    }
    
    func fetchAllHistories(on date: Date) async throws {
        sleep(1)
        for _ in 0...Int.random(in: 0...2) {
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
