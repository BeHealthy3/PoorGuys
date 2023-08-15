//
//  String+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/05/27.
//

import Foundation

extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
    
    func toInt() -> Int? {
        return Int(self)
    }
    
    func removeCommasAndConvertToInt() -> Int? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        if let number = numberFormatter.number(from: self) {
            return number.intValue
        }
        return nil
    }
}
