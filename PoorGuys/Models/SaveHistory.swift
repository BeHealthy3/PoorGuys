//
//  SaveHistory.swift
//  PoorGuys
//
//  Created by 권승용 on 2023/06/15.
//

import Foundation

enum SaveCategory: String {
    case transport, food, shopping, impulseBuy, dessert, hobby, subscribtion, mobileGame, coffee, present, drink, secondHandDealings
    
    var iconName: String {
        switch self {
        case .transport:
            return "transport"
        case .food:
            return "food"
        case .shopping:
            return "shopping"
        case .impulseBuy:
            return "impulseBuy"
        case .dessert:
            return "dessert"
        case .hobby:
            return "hobby"
        case .subscribtion:
            return "subscribtion"
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
        case .impulseBuy:
            return "뽐뿌"
        case .dessert:
            return "간식"
        case .hobby:
            return "취미"
        case .subscribtion:
            return "구독"
        case .mobileGame:
            return "현질"
        case .coffee:
            return "커피"
        case .present:
            return "선물"
        case .drink:
            return "술"
        case .secondHandDealings:
            return "중고"
        }
    }
}

enum SaveHistoryState {
    case saved, wasted
}

struct SaveHistory: Identifiable {
    let id = UUID().uuidString
    var category: SaveCategory
    var state: SaveHistoryState
    var price: Int
}
