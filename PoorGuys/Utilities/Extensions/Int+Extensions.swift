//
//  Int+Extensions.swift
//  PoorGuys
//
//  Created by 신동훈 on 2023/07/27.
//

import Foundation

extension Int {
    func toString() -> String {
        return String(self)
    }
    
    func formatToCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = ","
        
        if let formattedAmount = formatter.string(from: NSNumber(value: self)) {
            return formattedAmount
        } else {
            return "\(self)"
        }
    }
}
