//
//  SaveHistory.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

struct SaveHistory: Identifiable, Codable {
    let id: String
    var category: ConsumptionCategory
//    var state: SaveHistoryState
    var price: Int
    
    static func dummy() -> Self {
        SaveHistory(id: UUID().uuidString, category: ConsumptionCategory(rawValue: Int.random(in: (0...11)))!, price: Int.random(in: (-1000000...1000000)))
    }
    
    enum CodingKeys: String, CodingKey {
        case id, category, price
    }
}

extension SaveHistory {
    func asDictionary() -> [String: Any] {
        return [
            "id": id,
            "category": category.rawValue,
            "price": price,
        ]
    }
}

enum ConsumptionCategory: Int, Codable {
    case transport, food, shopping, flex, dessert, subscription, hobby, mobileGame, secondHandDealings, coffee, present, drink 
    
    var iconName: String {
        switch self {
        case .transport:
            return "transport"
        case .food:
            return "food"
        case .shopping:
            return "shopping"
        case .flex:
            return "flex"
        case .dessert:
            return "dessert"
        case .hobby:
            return "hobby"
        case .subscription:
            return "subscription"
        case .mobileGame:
            return "mobileGame"
        case .coffee:
            return "coffee"
        case .present:
            return "present"
        case .drink:
            return "drink"
        case .secondHandDealings:
            return "secondHandDealings"
        }
    }
    
    var categoryName: String {
        switch self {
        case .transport:
            return "교통"
        case .food:
            return "음식"
        case .shopping:
            return "쇼핑"
        case .flex:
            return "플렉스"
        case .dessert:
            return "간식"
        case .hobby:
            return "취미"
        case .subscription:
            return "정기구독"
        case .mobileGame:
            return "현질"
        case .coffee:
            return "커피"
        case .present:
            return "선물"
        case .drink:
            return "술"
        case .secondHandDealings:
            return "중고거래"
        }
    }
}

enum SaveHistoryViewMode {
    case saved, wasted
}

struct EncouragingWordsAndImage: Codable {
    var score: ConsumptionScore
    var words: [String]
    var image: String
    
    enum CodingKeys: String, CodingKey {
        case score, words, image
    }
}

extension EncouragingWordsAndImage {
    func asDictionary() -> [String : Any] {
        return [
            "score" : score.rawValue,
            "words" : words,
            "image" : image
        ]
    }
}

enum ConsumptionScore: String, Codable {
    case spendOver100
    case spendOver50
    case spendOver20
    case spendOver5
    case spendSome
    case zero
    case saveSome
    case saveOver5
    case saveOver20
    case saveOver50
    case saveOver100
    case unknownData
}
