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
        
        do {
            encouragingImageURL = encouragingWordsAndImages?.images.randomElement() ?? ""
            encouragingWords = try reorganizeEncouragingWordsIfNeeded(encouragingWordsAndImages?.words.randomElement() ?? "")
        } catch {
            print("로그인 에러") //todo: 에러처리
        }
    }
    
    func calculateMyConsumptionScore() {
        total = 0
        saveHistories.forEach { history in
            total += history.price
        }
        
        myScore = seperateConsumptionScore(from: total)
    }
}

extension SaveHistoryViewModelProtocol {
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
    
    private func reorganizeEncouragingWordsIfNeeded(_ fetchedEncouragingWords: String) throws -> String {
        guard let nickName = User.currentUser?.nickName else { throw LoginError.noCurrentUser }
        
        var EncouragingWords = fetchedEncouragingWords.replacingOccurrences(of: "UserNickName", with: nickName)

        if EncouragingWords.contains("{") && EncouragingWords.contains("}") {
            guard let strChoicesWithSlash = extractStringBetweenBrackets(EncouragingWords) else { return EncouragingWords }
            
            let strChoicesArrayWithoutSlash = strChoicesWithSlash.components(separatedBy: "/")

            guard strChoicesArrayWithoutSlash.count == 2 else { return EncouragingWords }

            var choice = ""

            if isLastCharacterKorean(nickName) {
                if let isLastWordOfNickNameJongseong = hasJongseong(nickName) {
                    choice = isLastWordOfNickNameJongseong ? strChoicesArrayWithoutSlash[1] : strChoicesArrayWithoutSlash[0]
                }

            } else {
                choice = "\(strChoicesArrayWithoutSlash[1])(\(strChoicesArrayWithoutSlash[0]))"
            }
            
            if let strChoicesWithSlashRange = EncouragingWords.range(of: "{\(strChoicesWithSlash)}") {
                EncouragingWords = EncouragingWords.replacingCharacters(in: strChoicesWithSlashRange, with: choice)
            }
        }

        return EncouragingWords
    }

    private func isLastCharacterKorean(_ nickName: String) -> Bool {
        var lastWordOfNickName: Character = nickName.last!
        
        let koreanCharacterSet = CharacterSet(charactersIn: "가"..."힣")
        let unicodeScalars = lastWordOfNickName.unicodeScalars
        
        return koreanCharacterSet.contains(UnicodeScalar(unicodeScalars[unicodeScalars.startIndex].value)!)
    }


    private func hasJongseong(_ KoreanString: String) -> Bool? {
        var charLastKoreanWord: Character
        
        if let lastWord = KoreanString.last {
            charLastKoreanWord = lastWord
            
            let unicodeScalar = charLastKoreanWord.unicodeScalars.first!
            let unicodeValue = Int(unicodeScalar.value)

            if unicodeValue >= 0xAC00 {
                let remainder = (unicodeValue - 0xAC00) % 28
                return remainder != 0
            }

            return false
        }
        
        return nil
    }

    private func extractStringBetweenBrackets(_ str: String) -> String? {
        guard let openingBracketIndex = str.firstIndex(of: "{"),
              let closingBracketIndex = str.firstIndex(of: "}") else {
            return nil
        }
        
        let startIndex = str.index(after: openingBracketIndex)
        let endIndex = str.index(before: closingBracketIndex)
        let extractedString = str[startIndex...endIndex]
        
        return String(extractedString)
    }

    private func extractStringBasedOnJongseong(_ str: String, hasJongSeong: Bool) -> String? {
        let components = str.components(separatedBy: "/")
        guard components.count == 2 else {
            return nil
        }
        
        return hasJongSeong ? components[1] : components[0]
    }
}

class MockSaveHistoryViewModel: SaveHistoryViewModelProtocol, ObservableObject {
    
    @Published var date: Date = Date()
    @Published var total: Int = 0
    @Published var saveHistories: [SaveHistory] = []
    @Published var encouragingWords: String = ""
    @Published var encouragingImageURL: String = ""
    
    var encouragingWordsAndImagesCollection: [EncouragingWordsAndImages] = []
    var myScore: ConsumptionScore = .zero
    
    func fetchAllEncouragementWordsAndImages() async throws {
        sleep(1)
        encouragingWordsAndImagesCollection = [EncouragingWordsAndImages(score: .spendOver100, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver50, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver20, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .spendOver5, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .zero, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveSome, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]) ,EncouragingWordsAndImages(score: .saveSome, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver5, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver20, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver50, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"]), EncouragingWordsAndImages(score: .saveOver100, words: ["UserNickName{는/이는} 내일부터 거지하려나보다ㅋㅋㅋㅋ!", "와 UserNickName거지 탄생축하축하축하축하축하!"], images: ["https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F360A6C62-C0FD-4955-A94D-9365D2B3FD6D.png?alt=media&token=59e40fdd-9219-46ee-98ce-afc1358114fc", "https://firebasestorage.googleapis.com/v0/b/poorguys-ad187.appspot.com/o/encouraging_Images%2F42BD61DF-34CA-4CA5-B40A-451D03474F1C.png?alt=media&token=fb073485-2885-474f-bc1d-61a0a878a36d"])]
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
